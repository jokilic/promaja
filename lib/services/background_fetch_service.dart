import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/promaja_log/promaja_log_level.dart';
import '../util/initialization.dart';
import '../util/log_data.dart';
import 'hive_service.dart';
import 'home_widget_service.dart';
import 'logger_service.dart';
import 'notification_service.dart';

///
/// Initializes `BackgroundFetch`
/// Used for scheduling tasks
///

final backgroundFetchInitProvider = FutureProvider<void>(
  (_) async {
    /// Initialization of [BackgroundFetch]
    try {
      /// Register headless task
      await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

      /// Configure [BackgroundFetch]
      await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 60,
          startOnBoot: true,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ),

        /// Task logic
        (taskId) async {
          try {
            /// Initialize Flutter related tasks
            WidgetsFlutterBinding.ensureInitialized();
            DartPluginRegistrant.ensureInitialized();

            /// Initialize [EasyLocalization]
            await initializeLocalization();

            /// Initialize services
            final container = await initializeServices();

            /// Everything initialized successfully
            if (container != null) {
              /// Get `PromajaSettings`
              final settings = container.read(hiveProvider.notifier).getPromajaSettingsFromBox();

              ///
              /// Notifications
              ///
              await container.read(notificationProvider).handleNotifications(
                    settings: settings,
                    container: container,
                  );

              ///
              /// Widget
              ///
              await container.read(homeWidgetProvider).handleWidget(
                    settings: settings,
                    container: container,
                  );
            }
          }

          /// Some generic error happened, throw error
          catch (e) {
            final logger = LoggerService();
            final hive = HiveService(logger);
            await hive.init();

            logPromajaEvent(
              logger: logger,
              hive: hive,
              text: 'BackgroundFetchService -> backgroundFetchInit -> $e',
              logLevel: PromajaLogLevel.info,
              isError: true,
            );
          }

          /// Finish task
          BackgroundFetch.finish(taskId);
        },

        /// Task timeout logic
        (taskId) async {
          final logger = LoggerService();
          final hive = HiveService(logger);
          await hive.init();

          logPromajaEvent(
            logger: logger,
            hive: hive,
            text: 'BackgroundFetchService -> backgroundFetchInit -> Task timed-out -> $taskId',
            logLevel: PromajaLogLevel.info,
            isError: true,
          );

          BackgroundFetch.finish(taskId);
        },
      );

      /// Start [BackgroundFetch]
      await BackgroundFetch.start();

      final logger = LoggerService();
      final hive = HiveService(logger);
      await hive.init();

      logPromajaEvent(
        logger: logger,
        hive: hive,
        text: 'BackgroundFetchService -> backgroundFetchInit -> initialize -> Success',
        logLevel: PromajaLogLevel.info,
        isError: false,
      );
    } catch (e) {
      final logger = LoggerService();
      final hive = HiveService(logger);
      await hive.init();

      logPromajaEvent(
        logger: logger,
        hive: hive,
        text: 'BackgroundFetchService -> backgroundFetchInit -> initialize -> $e',
        logLevel: PromajaLogLevel.info,
        isError: true,
      );
    }
  },
  name: 'BackgroundFetchInitProvider',
);

@pragma('vm:entry-point')
Future<void> backgroundFetchHeadlessTask(HeadlessTask task) async {
  final taskId = task.taskId;
  final isTimeout = task.timeout;

  /// Task is timed out, finish it immediately
  if (isTimeout) {
    final logger = LoggerService();
    final hive = HiveService(logger);
    await hive.init();

    logPromajaEvent(
      logger: logger,
      hive: hive,
      text: 'BackgroundFetchService -> backgroundFetchHeadlessTask -> Task timed-out -> $taskId',
      logLevel: PromajaLogLevel.info,
      isError: true,
    );

    BackgroundFetch.finish(taskId);
    return;
  }

  ///
  /// Task logic
  ///
  try {
    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    /// Initialize [EasyLocalization]
    await initializeLocalization();

    /// Initialize services
    final container = await initializeServices();

    /// Everything initialized successfully
    if (container != null) {
      /// Get `PromajaSettings`
      final settings = container.read(hiveProvider.notifier).getPromajaSettingsFromBox();

      ///
      /// Notifications
      ///
      await container.read(notificationProvider).handleNotifications(
            settings: settings,
            container: container,
          );

      ///
      /// Widget
      ///
      await container.read(homeWidgetProvider).handleWidget(
            settings: settings,
            container: container,
          );
    }

    final logger = LoggerService();
    final hive = HiveService(logger);
    await hive.init();

    logPromajaEvent(
      logger: logger,
      hive: hive,
      text: 'BackgroundFetchService -> backgroundFetchHeadlessTask -> Success',
      logLevel: PromajaLogLevel.info,
      isError: false,
    );
  }

  /// Some generic error happened, throw error
  catch (e) {
    final logger = LoggerService();
    final hive = HiveService(logger);
    await hive.init();

    logPromajaEvent(
      logger: logger,
      hive: hive,
      text: 'BackgroundFetchService -> backgroundFetchHeadlessTask -> $e',
      logLevel: PromajaLogLevel.info,
      isError: true,
    );
  }

  /// Finish task
  BackgroundFetch.finish(taskId);
}
