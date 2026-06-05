import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../util/dependencies.dart';
import 'home_widget_service.dart';
import 'notification_service.dart';

class BackgroundFetchService {
  ///
  /// VARIABLES
  ///

  final minimumFetchInterval = 60;

  ///
  /// INIT
  ///

  Future<void> init() async {
    /// Register Android background events after the app is terminated
    if (defaultTargetPlatform == TargetPlatform.android) {
      await BackgroundFetch.registerHeadlessTask(promajaBackgroundHeadlessTask);
    }

    /// Initialize [BackgroundFetch]
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: minimumFetchInterval,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiredNetworkType: NetworkType.ANY,
      ),
      (taskId) async {
        try {
          await promajaBackgroundCallback();
        } catch (_) {
        } finally {
          await BackgroundFetch.finish(taskId);
        }
      },
      (taskId) async {
        await BackgroundFetch.finish(taskId);
      },
    );
  }
}

@pragma('vm:entry-point')
Future<void> promajaBackgroundHeadlessTask(HeadlessEvent task) async {
  if (task.timeout) {
    await BackgroundFetch.finish(task.taskId);
    return;
  }

  try {
    await promajaBackgroundCallback();
  } catch (_) {
  } finally {
    await BackgroundFetch.finish(task.taskId);
  }
}

@pragma('vm:entry-point')
Future<void> promajaBackgroundCallback() async {
  try {
    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    /// Initialize [EasyLocalization]
    final locale = await initializeLocalization();

    /// Initialize services used for background work
    await initializeServicesBackground();

    ///
    /// Notifications
    ///
    await getIt.get<NotificationService>().handleNotifications();

    ///
    /// Widget
    ///
    await getIt.get<HomeWidgetService>().handleWidget(
      languageCode: locale.languageCode,
    );
  } catch (_) {}
}
