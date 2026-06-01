import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_workmanager/native_workmanager.dart';

import '../util/dependencies.dart';
import 'home_widget_service.dart';
import 'notification_service.dart';

class WorkManagerService {
  ///
  /// VARIABLES
  ///

  final promajaBackgroundTaskId = 'promaja_background_task';
  final promajaBackgroundWorkerId = 'promaja_background_worker';
  final promajaBackgroundTaskTag = 'promaja_background_tag';

  ///
  /// INIT
  ///

  Future<void> init() async {
    /// Initialize [NativeWorkManager]
    await NativeWorkManager.initialize(
      debugMode: kDebugMode,
      registerPlugins: true,
      dartWorkers: {
        promajaBackgroundWorkerId: promajaBackgroundCallback,
      },
    );

    /// Register periodic task
    await NativeWorkManager.enqueue(
      taskId: promajaBackgroundTaskId,
      trigger: const TaskTrigger.periodic(
        Duration(hours: 1),
        flexInterval: Duration(minutes: 15),
      ),
      worker: DartWorker(
        callbackId: promajaBackgroundWorkerId,
        autoDispose: true,
      ),
      constraints: Constraints.networkRequired,
      tag: promajaBackgroundTaskTag,
    );
  }
}

@pragma('vm:entry-point')
Future<bool> promajaBackgroundCallback(Map<String, dynamic>? input) async {
  try {
    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    /// Initialize [EasyLocalization]
    await initializeLocalization();

    /// Initialize services
    await initializeServices(
      initializeWorkManager: false,
    );

    ///
    /// Notifications
    ///
    await getIt.get<NotificationService>().handleNotifications();

    ///
    /// Widget
    ///
    // TODO: Perhaps pass `languageCode` from `Map<String, dynamic>? input` if possible
    await getIt.get<HomeWidgetService>().handleWidget(languageCode: 'en');

    return true;
  } catch (_) {
    return false;
  }
}
