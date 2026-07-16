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

/// Registers phone location service without starting its refresh logic
void registerPhoneLocationService() {
  /// PhoneLocation
  if (!getIt.isRegistered<PhoneLocationService>()) {
    getIt.registerSingleton(
      PhoneLocationService(
        hive: getIt.get<HiveService>(),
        api: getIt.get<APIService>(),
        location: getIt.get<LocationService>(),
      ),
    );
  }
}

/// Registers background fetch service
void registerBackgroundFetchService() {
  /// BackgroundFetch
  if (!getIt.isRegistered<BackgroundFetchService>()) {
    getIt.registerSingleton(
      BackgroundFetchService(),
    );
  }
}

/// Registers notification service
void registerNotificationService() {
  /// Notification
  if (!getIt.isRegistered<NotificationService>()) {
    getIt.registerSingleton(
      NotificationService(
        hive: getIt.get<HiveService>(),
        api: getIt.get<APIService>(),
        location: getIt.get<LocationService>(),
      ),
    );
  }
}

/// Registers home widget service
void registerHomeWidgetService({
  required String languageCode,
  required bool waitForPhoneLocationRefresh,
  required bool updateInstalledWidgetsOnInit,
}) {
  /// HomeWidget
  if (!getIt.isRegistered<HomeWidgetService>()) {
    getIt.registerSingleton(
      HomeWidgetService(
        hive: getIt.get<HiveService>(),
        api: getIt.get<APIService>(),
        location: getIt.get<LocationService>(),
        languageCode: languageCode,
        initialPhoneLocationRefresh: waitForPhoneLocationRefresh ? getIt.get<PhoneLocationService>().initialRefresh : null,
        updateInstalledWidgetsOnInit: updateInstalledWidgetsOnInit,
      ),
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

/// Initializes services before UI
Future<void> initializeMainServices({required String languageCode}) async {
  final isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  registerCoreServices();
  registerScreenService();

  /// Hive and the initial screen must be ready before the app is started
  await getIt.allReady();

  /// Register lightweight service so screens can access them immediately
  registerPhoneLocationService();

  if (isMobile) {
    registerBackgroundFetchService();
    registerNotificationService();
    registerHomeWidgetService(
      languageCode: languageCode,
      waitForPhoneLocationRefresh: false,
      updateInstalledWidgetsOnInit: false,
    );
  }
}

/// Initializes non-critical services after UI
Future<void> initializeServicesAfterAppStart({required String languageCode}) async {
  final isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  final phoneLocation = getIt.get<PhoneLocationService>();

  /// Start GPS refresh
  await runLateInitialization(
    phoneLocation.init,
  );

  if (!isMobile) {
    return;
  }

  final backgroundFetch = getIt.get<BackgroundFetchService>();
  final notification = getIt.get<NotificationService>();
  final homeWidget = getIt.get<HomeWidgetService>();

  await Future.wait([
    runLateInitialization(
      backgroundFetch.init,
    ),
    runLateInitialization(
      notification.init,
    ),
    runLateInitialization(() async {
      await homeWidget.init();
      await phoneLocation.initialRefresh;
      await homeWidget.updateInstalledWidgets(
        languageCode: languageCode,
      );
    }),
  ]);
}

/// Prevents initialization failure from affecting other startup work
Future<void> runLateInitialization(Future<void> Function() initialize) async {
  try {
    await initialize();
  } catch (_) {}
}

/// Initialize only services needed by background notifications and widgets
Future<void> initializeServicesBackground({required String languageCode}) async {
  final isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  registerCoreServices();

  /// Background work requires core storage and API services before registration
  await getIt.allReady();

  if (isMobile) {
    registerNotificationService();
    registerHomeWidgetService(
      languageCode: languageCode,
      waitForPhoneLocationRefresh: false,
      updateInstalledWidgetsOnInit: false,
    );

    await Future.wait([
      getIt.get<NotificationService>().init(),
      getIt.get<HomeWidgetService>().init(),
    ]);
  }
}

/// Initialize only services needed to handle notifications
Future<void> initializeServicesNotificationTap() async {
  final isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  registerCoreServices();
  registerScreenService();

  /// Notification handling needs persisted data and navigation state
  await getIt.allReady();

  if (isMobile) {
    registerNotificationService();
    await getIt.get<NotificationService>().init();
  }
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
