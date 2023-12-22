// ignore_for_file: implementation_imports

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/easy_localization_controller.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

import '../generated/codegen_loader.g.dart';
import '../services/api_service.dart';
import '../services/background_fetch_service.dart';
import '../services/dio_service.dart';
import '../services/hive_service.dart';
import '../services/home_widget_service.dart';
import '../services/logger_service.dart';
import '../services/notification_service.dart';

/// Initialize services & pass `container`
Future<ProviderContainer?> initializeServices() async {
  try {
    final container = ProviderContainer(
      observers: [
        RiverpodLogger(
          LoggerService(),
        ),
      ],
    )
      ..read(loggerProvider)
      ..read(dioProvider)
      ..read(apiProvider);

    await container.read(backgroundFetchInitProvider.future);

    final hive = container.read(hiveProvider.notifier);
    await hive.init();

    container.read(homeWidgetProvider);

    final notifications = container.read(notificationProvider);
    await notifications.init();

    return container;
  } catch (e) {
    final error = 'initializeServices -> $e';
    Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 3,
        lineLength: 50,
        noBoxingByDefault: true,
      ),
    ).e(error);
    return null;
  }
}

/// Initialize [EasyLocalization]
Future<void> initializeLocalization() async {
  try {
    await EasyLocalization.ensureInitialized();

    final controller = EasyLocalizationController(
      useOnlyLangCode: true,
      supportedLocales: const [Locale('hr'), Locale('en')],
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
  } catch (e) {
    final error = 'initializeLocalization -> $e';
    Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 3,
        lineLength: 50,
        noBoxingByDefault: true,
      ),
    ).e(error);
  }
}
