import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
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
          debugPrint('OnFetch -> catch -> $e');
        } finally {
          await BackgroundFetch.finish(taskId);
        }
      },
      (taskId) async {
        debugPrint('OnTimeout -> $taskId');
        await BackgroundFetch.finish(taskId);
      },
    );

    debugPrint('BackgroundFetch -> Configure status -> $status');
  }
}

@pragma('vm:entry-point')
Future<void> promajaBackgroundHeadlessTask(HeadlessEvent task) async {
  if (task.timeout) {
    debugPrint('BackgroundFetch -> Headless timeout -> ${task.taskId}');
    await BackgroundFetch.finish(task.taskId);
    return;
  }

  try {
    await promajaBackgroundCallback();
  } catch (e) {
    debugPrint('PromajaBackgroundHeadlessTask -> catch -> $e');
  } finally {
    await BackgroundFetch.finish(task.taskId);
  }
}

@pragma('vm:entry-point')
Future<void> promajaBackgroundCallback() async {
  try {
    debugPrint('BackgroundFetch -> Starting background callback');

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
    debugPrint('PromajaBackgroundCallback -> catch -> $e');
  }
}
