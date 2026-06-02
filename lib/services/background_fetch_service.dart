import 'dart:developer';
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
      final isRegistered = await BackgroundFetch.registerHeadlessTask(promajaBackgroundHeadlessTask);
      log('BackgroundFetch -> Headless task registered -> $isRegistered');
    }

    /// Initialize [BackgroundFetch]
    final status = await BackgroundFetch.configure(
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
        } catch (e) {
          log('OnFetch -> catch -> $e');
        } finally {
          await BackgroundFetch.finish(taskId);
        }
      },
      (taskId) async {
        log('OnTimeout -> $taskId');
        await BackgroundFetch.finish(taskId);
      },
    );

    log('BackgroundFetch -> Configure status -> $status');
  }
}

@pragma('vm:entry-point')
Future<void> promajaBackgroundHeadlessTask(HeadlessEvent task) async {
  if (task.timeout) {
    log('BackgroundFetch -> Headless timeout -> ${task.taskId}');
    await BackgroundFetch.finish(task.taskId);
    return;
  }

  try {
    await promajaBackgroundCallback();
  } catch (e) {
    log('PromajaBackgroundHeadlessTask -> catch -> $e');
  } finally {
    await BackgroundFetch.finish(task.taskId);
  }
}

@pragma('vm:entry-point')
Future<void> promajaBackgroundCallback() async {
  try {
    log('BackgroundFetch -> Starting background callback');

    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    /// Initialize [EasyLocalization]
    final locale = await initializeLocalization();

    /// Initialize services
    await initializeServices(
      initializeBackgroundFetch: false,
    );

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
  } catch (e) {
    log('PromajaBackgroundCallback -> catch -> $e');
  }
}
