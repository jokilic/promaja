import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logger_service.dart';

///
/// Service which initializes `Notifications`
/// Used for showing notifications on the phone
///

final notificationProvider = Provider<NotificationService>(
  (ref) => NotificationService(
    logger: ref.watch(loggerProvider),
  ),
  name: 'NotificationProvider',
);

class NotificationService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  NotificationService({
    required this.logger,
  })

  ///
  /// INIT
  ///

  {
    () async {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await initializeNotifications();
    }();
  }

  ///
  /// VARIABLES
  ///

  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ///
  /// METHODS
  ///

  /// Initializes [FlutterLocalNotifications] plugin
  Future<bool> initializeNotifications() async {
    try {
      return true;
    } catch (e) {
      final error = 'NotificationService -> initializeNotifications() -> $e';
      logger.e(error);
      return false;
    }
  }

  /// Triggers notification permission dialog
  Future<bool> requestNotificationPermissions() async {
    try {
      final permissionGranted =
          await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      return permissionGranted ?? false;
    } catch (e) {
      final error = 'NotificationService -> requestNotificationPermissions() -> $e';
      logger.e(error);
      return false;
    }
  }
}
