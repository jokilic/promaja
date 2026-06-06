// ignore_for_file: implementation_imports

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/easy_localization_controller.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../generated/codegen_loader.g.dart';
import '../services/api_service.dart';
import '../services/background_fetch_service.dart';
import '../services/dio_service.dart';
import '../services/hive_service.dart';
import '../services/home_widget_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/phone_location_service.dart';
import '../services/screen_service.dart';

final getIt = GetIt.instance;

/// Registers a class if it's not already initialized
/// Optionally runs a function with newly registered class
T registerIfNotInitialized<T extends Object>(
  T Function() factoryFunc, {
  String? instanceName,
  void Function(T controller)? afterRegister,
}) {
  if (!getIt.isRegistered<T>(instanceName: instanceName)) {
    getIt.registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
      onCreated: afterRegister != null ? (instance) => afterRegister(instance) : null,
    );
  }

  return getIt.get<T>(instanceName: instanceName);
}

/// Unregisters a class if it's not already disposed
/// Optionally runs a function with newly unregistered class
void unRegisterIfNotDisposed<T extends Object>({
  String? instanceName,
  void Function(T controller)? afterUnregister,
}) {
  if (getIt.isRegistered<T>(instanceName: instanceName)) {
    getIt.unregister<T>(
      disposingFunction: afterUnregister,
      instanceName: instanceName,
    );
  }
}

/// Registers services shared by app and background
void registerCoreServices() {
  /// Dio
  if (!getIt.isRegistered<DioService>()) {
    getIt.registerSingletonAsync(
      () async => DioService(),
    );
  }

  /// Hive
  if (!getIt.isRegistered<HiveService>()) {
    getIt.registerSingletonAsync(
      () async {
        final hive = HiveService();
        await hive.init();
        return hive;
      },
    );
  }

  /// API
  if (!getIt.isRegistered<APIService>()) {
    getIt.registerSingletonAsync(
      () async => APIService(
        dio: getIt.get<DioService>().dio,
      ),
      dependsOn: [DioService],
    );
  }

  /// Location
  if (!getIt.isRegistered<LocationService>()) {
    getIt.registerSingletonAsync(
      () async => LocationService(
        hive: getIt.get<HiveService>(),
      ),
      dependsOn: [HiveService],
    );
  }
}

/// Registers phone location service and starts its refresh logic
void registerPhoneLocationService() {
  /// PhoneLocation
  if (!getIt.isRegistered<PhoneLocationService>()) {
    getIt.registerSingletonAsync(
      () async {
        final phoneLocation = PhoneLocationService(
          hive: getIt.get<HiveService>(),
          api: getIt.get<APIService>(),
          location: getIt.get<LocationService>(),
        );
        await phoneLocation.init();
        return phoneLocation;
      },
      dependsOn: [HiveService, APIService, LocationService],
    );
  }
}

/// Registers background fetch service
void registerBackgroundFetchService() {
  /// BackgroundFetch
  if (!getIt.isRegistered<BackgroundFetchService>()) {
    getIt.registerSingletonAsync(
      () async {
        final backgroundFetch = BackgroundFetchService();
        await backgroundFetch.init();
        return backgroundFetch;
      },
    );
  }
}

/// Registers notification service
void registerNotificationService() {
  /// Notification
  if (!getIt.isRegistered<NotificationService>()) {
    getIt.registerSingletonAsync(
      () async {
        final notification = NotificationService(
          hive: getIt.get<HiveService>(),
          api: getIt.get<APIService>(),
          location: getIt.get<LocationService>(),
        );
        await notification.init();
        return notification;
      },
      dependsOn: [HiveService, APIService, LocationService],
    );
  }
}

/// Registers home widget service
void registerHomeWidgetService() {
  /// HomeWidget
  if (!getIt.isRegistered<HomeWidgetService>()) {
    getIt.registerSingletonAsync(
      () async => HomeWidgetService(
        hive: getIt.get<HiveService>(),
        api: getIt.get<APIService>(),
        location: getIt.get<LocationService>(),
      ),
      dependsOn: [HiveService, APIService, LocationService],
    );
  }
}

/// Registers screen service
void registerScreenService() {
  /// Screen
  if (!getIt.isRegistered<ScreenService>()) {
    getIt.registerSingletonAsync(
      () async => ScreenService(
        hive: getIt.get<HiveService>(),
      ),
      dependsOn: [HiveService],
    );
  }
}

/// Initialize services
Future<void> initializeServices() async {
  final isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  registerCoreServices();
  registerPhoneLocationService();

  if (isMobile) {
    registerBackgroundFetchService();
    registerNotificationService();
    registerHomeWidgetService();
  }

  registerScreenService();

  /// Wait for initialization to finish
  await getIt.allReady();
}

/// Initialize only services needed by background notifications and widgets
Future<void> initializeServicesBackground() async {
  final isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  registerCoreServices();

  if (isMobile) {
    registerNotificationService();
    registerHomeWidgetService();
  }

  /// Wait for initialization to finish
  await getIt.allReady();
}

/// Initialize only services needed to handle notifications
Future<void> initializeServicesNotificationTap() async {
  final isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  registerCoreServices();

  if (isMobile) {
    registerNotificationService();
  }

  registerScreenService();

  /// Wait for initialization to finish
  await getIt.allReady();
}

/// Initialize [EasyLocalization] and return the active locale
Future<Locale> initializeLocalization() async {
  await EasyLocalization.ensureInitialized();

  final controller = EasyLocalizationController(
    useOnlyLangCode: true,
    supportedLocales: const [
      Locale('hr'),
      Locale('en'),
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('hr'),
    saveLocale: true,
    useFallbackTranslations: true,
    assetLoader: const CodegenLoader(),
    onLoadError: (e) {},
  );

  await controller.loadTranslations();

  Localization.load(
    controller.locale,
    translations: controller.translations,
    fallbackTranslations: controller.fallbackTranslations,
  );

  await initializeDateFormatting('en');
  await initializeDateFormatting('hr');

  return controller.locale;
}
