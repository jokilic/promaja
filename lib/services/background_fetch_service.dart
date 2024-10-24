import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../util/initialization.dart';
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
            /// If task is triggered between `00:00` and `06:00`, don't do anything
            final hour = DateTime.now().hour;
            if (hour >= 0 && hour <= 6) {
              await BackgroundFetch.finish(taskId);
              return;
            }

            /// Initialize Flutter related tasks
            WidgetsFlutterBinding.ensureInitialized();
            DartPluginRegistrant.ensureInitialized();

            /// Initialize [EasyLocalization]
            await initializeLocalization();

            /// Initialize services
            final container = await initializeServices();

            /// Everything initialized successfully
            if (container != null) {
              ///
              /// Notifications
              ///
              await container.read(notificationProvider).handleNotifications();

              ///
              /// Widget
              ///
              await container.read(homeWidgetProvider).handleWidget();
            }
          }

          /// Some generic error happened, throw error
          catch (e) {
            unawaited(Sentry.captureException('BackgroundFetchInitProvider -> taskCallback -> catch -> $e'));
            final logger = LoggerService();
            final hive = HiveService(logger);
            await hive.init();
          }

          /// Finish task
          await BackgroundFetch.finish(taskId);
        },

        /// Task timeout logic
        (taskId) async {
          final logger = LoggerService();
          final hive = HiveService(logger);
          await hive.init();

          await BackgroundFetch.finish(taskId);
        },
      );

      /// Start [BackgroundFetch]
      await BackgroundFetch.start();

      final logger = LoggerService();
      final hive = HiveService(logger);
      await hive.init();
    } catch (e) {
      unawaited(Sentry.captureException('BackgroundFetchInitProvider -> catch -> $e'));
      final logger = LoggerService();
      final hive = HiveService(logger);
      await hive.init();
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

    await BackgroundFetch.finish(taskId);
    return;
  }

  ///
  /// Task logic
  ///
  try {
    /// If task is triggered between `00:00` and `06:00`, don't do anything
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour <= 6) {
      await BackgroundFetch.finish(taskId);
      return;
    }

    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    /// Initialize [EasyLocalization]
    await initializeLocalization();

    /// Initialize services
    final container = await initializeServices();

    /// Everything initialized successfully
    if (container != null) {
      ///
      /// Notifications
      ///
      await container.read(notificationProvider).handleNotifications();

      ///
      /// Widget
      ///
      await container.read(homeWidgetProvider).handleWidget();
    }

    final logger = LoggerService();
    final hive = HiveService(logger);
    await hive.init();
  }

  /// Some generic error happened, throw error
  catch (e) {
    unawaited(Sentry.captureException('BackgroundFetchInitProvider -> catch -> $e'));
    final logger = LoggerService();
    final hive = HiveService(logger);
    await hive.init();
  }

  /// Finish task
  await BackgroundFetch.finish(taskId);
}
