import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/initialization.dart';
import 'home_widget_service.dart';
import 'notification_service.dart';

///
/// Initializes `BackgroundFetch`
/// Used for scheduling tasks
///

/// Initialization of [BackgroundFetch]
final backgroundFetchInitProvider = FutureProvider<void>(
  (_) async {
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
          await container.read(homeWidgetProvider).handleWidget(languageCode: 'en');
        }

        /// Finish task
        await BackgroundFetch.finish(taskId);
      },

      /// Task timeout logic
      (taskId) async {
        await BackgroundFetch.finish(taskId);
      },
    );

    /// Start [BackgroundFetch]
    await BackgroundFetch.start();
  },
  name: 'BackgroundFetchInitProvider',
);

@pragma('vm:entry-point')
Future<void> backgroundFetchHeadlessTask(HeadlessTask task) async {
  final taskId = task.taskId;
  final isTimeout = task.timeout;

  /// Task is timed out, finish it immediately
  if (isTimeout) {
    await BackgroundFetch.finish(taskId);
    return;
  }

  ///
  /// Task logic
  ///

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
    await container.read(homeWidgetProvider).handleWidget(languageCode: 'en');
  }

  /// Finish task
  await BackgroundFetch.finish(taskId);
}
