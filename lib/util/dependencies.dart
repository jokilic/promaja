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
import '../services/dio_service.dart';
import '../services/hive_service.dart';
import '../services/home_widget_service.dart';
import '../services/location_service.dart';
import '../services/logger_service.dart';
import '../services/notification_service.dart';
import '../services/screen_service.dart';
import '../services/work_manager_service.dart';

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

/// Initialize services
Future<void> initializeServices() async {
  final isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

  /// Logger
  if (!getIt.isRegistered<LoggerService>()) {
    getIt.registerSingletonAsync(
      () async => LoggerService(),
    );
  }

  /// Dio
  if (!getIt.isRegistered<DioService>()) {
    getIt.registerSingletonAsync(
      () async => DioService(
        logger: getIt.get<LoggerService>(),
      ),
      dependsOn: [LoggerService],
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
        logger: getIt.get<LoggerService>(),
        dio: getIt.get<DioService>().dio,
        hive: getIt.get<HiveService>(),
      ),
      dependsOn: [LoggerService, DioService, HiveService],
    );
  }

  if (isMobile) {
    /// WorkManager
    if (!getIt.isRegistered<WorkManagerService>()) {
      getIt.registerSingletonAsync(
        () async => WorkManagerService(
          logger: getIt.get<LoggerService>(),
        ),
        dependsOn: [LoggerService],
      );
    }

    /// Notification
    if (!getIt.isRegistered<NotificationService>()) {
      getIt.registerSingletonAsync(
        () async {
          final notification = NotificationService(
            logger: getIt.get<LoggerService>(),
            hive: getIt.get<HiveService>(),
            api: getIt.get<APIService>(),
          );
          await notification.init();
          return notification;
        },
        dependsOn: [LoggerService, HiveService, APIService],
      );
    }

    /// HomeWidget
    if (!getIt.isRegistered<HomeWidgetService>()) {
      getIt.registerSingletonAsync(
        () async => HomeWidgetService(
          logger: getIt.get<LoggerService>(),
          hive: getIt.get<HiveService>(),
          api: getIt.get<APIService>(),
        ),
        dependsOn: [LoggerService, HiveService, APIService],
      );
    }
  }

  /// Location
  if (!getIt.isRegistered<LocationService>()) {
    getIt.registerSingletonAsync(
      () async => LocationService(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
      ),
      dependsOn: [LoggerService, HiveService],
    );
  }

  /// Screen
  if (!getIt.isRegistered<ScreenService>()) {
    getIt.registerSingletonAsync(
      () async => ScreenService(
        logger: getIt.get<LoggerService>(),
        hive: getIt.get<HiveService>(),
      ),
      dependsOn: [LoggerService, HiveService],
    );
  }
}

/// Initialize [EasyLocalization]
Future<void> initializeLocalization() async {
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
}
