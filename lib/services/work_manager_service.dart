import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_workmanager/native_workmanager.dart';

import '../util/dependencies.dart';
import 'home_widget_service.dart';
import 'notification_service.dart';

///
/// Initializes `NativeWorkManager`
/// Used for scheduling tasks
///

const promajaBackgroundTaskId = 'promaja_background_task';
const promajaBackgroundWorkerId = 'promaja_background_worker';
const promajaBackgroundTaskTag = 'promaja_background_tag';

/// Initialization of [NativeWorkManager]
final workManagerInitProvider = FutureProvider<void>(
  (_) async {
    /// Initialize [NativeWorkManager]
    await NativeWorkManager.initialize(
      debugMode: kDebugMode,
      dartWorkers: {
        promajaBackgroundWorkerId: promajaBackgroundCallback,
      },
      registerPlugins: true,
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
  },
  name: 'NativeWorkManagerInitProvider',
);

@pragma('vm:entry-point')
Future<bool> promajaBackgroundCallback(Map<String, dynamic>? input) async {
  try {
    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    /// Initialize [EasyLocalization]
    await initializeLocalization();

    /// Initialize services without re-registering the periodic background task.
    final initialization = await initializeServices(
      initializeBackgroundTasks: false,
    );

    /// Everything initialized successfully
    if (initialization?.container != null) {
      ///
      /// Notifications
      ///
      await initialization!.container!.read(notificationProvider).handleNotifications();

      ///
      /// Widget
      ///
      await initialization.container!.read(homeWidgetProvider).handleWidget(languageCode: 'en');
    }

    return true;
  } catch (_) {
    return false;
  }
}
