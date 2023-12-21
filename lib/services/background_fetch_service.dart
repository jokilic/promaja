import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../util/initialization.dart';
import 'hive_service.dart';
import 'home_widget_service.dart';
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
            final error = 'backgroundFetchHeadlessTask -> $e';
            Logger().e(error);
          }

          /// Finish task
          BackgroundFetch.finish(taskId);
        },

        /// Task timeout logic
        (taskId) async {
          Logger().e('Task timed-out: $taskId');
          BackgroundFetch.finish(taskId);
        },
      );

      /// Start [BackgroundFetch]
      await BackgroundFetch.start();
    } catch (e) {
      final error = 'backgroundFetchInit -> initialize -> $e';
      Logger().e(error);
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
    Logger().e('Headless task timed-out: $taskId');
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
  }

  /// Some generic error happened, throw error
  catch (e) {
    final error = 'backgroundFetchHeadlessTask -> $e';
    Logger().e(error);
  }

  /// Finish task
  BackgroundFetch.finish(taskId);
}
