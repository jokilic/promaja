import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import '../util/initialization.dart';
import 'home_widget_service.dart';
import 'notification_service.dart';

///
/// Initializes `WorkManager`
/// Used for scheduling tasks
///

/// Initialization of [WorkManager]
final workManagerInitProvider = FutureProvider<void>(
  (_) async {
    /// Initialize [Workmanager]
    await Workmanager().initialize(callbackDispatcher);

    /// Register periodic task
    await Workmanager().registerPeriodicTask(
      'promaja_background_task',
      'promaja_background_tag',
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
      ),
    );
  },
  name: 'WorkManagerInitProvider',
);

@pragma('vm:entry-point')
void callbackDispatcher() => Workmanager().executeTask(
  (_, __) async {
    try {
      /// Initialize Flutter related tasks
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();

      /// Initialize [EasyLocalization]
      await initializeLocalization();

      /// Initialize services
      final initialization = await initializeServices();

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

      return Future.value(true);
    } catch (_) {
      return Future.value(false);
    }
  },
);
