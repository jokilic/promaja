import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/icons.dart';
import '../models/current_weather/response_current_weather.dart';
import '../util/weather.dart';
import 'logger_service.dart';

///
/// Service which initializes `Notifications`
/// Used for showing notifications on the phone
///

final notificationProvider = Provider<NotificationService>(
  (ref) => NotificationService(
    ref.watch(loggerProvider),
  ),
  name: 'NotificationProvider',
);

class NotificationService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  NotificationService(this.logger);

  ///
  /// VARIABLES
  ///

  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final androidNotificationDetails = const AndroidNotificationDetails(
    'promaja_channel_id',
    'Promaja notifications',
    channelDescription: 'Notifications shown by the Promaja app',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  final iosNotificationDetails = const DarwinNotificationDetails(
    categoryIdentifier: 'promaja_category_id',
  );

  final macOSNotificationDetails = const DarwinNotificationDetails(
    categoryIdentifier: 'promaja_category_id',
  );

  final linuxNotificationDetails = const LinuxNotificationDetails();

  late final notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
    macOS: macOSNotificationDetails,
    linux: linuxNotificationDetails,
  );

  ///
  /// INIT
  ///

  Future<void> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await configureTimeZone();
    await initializeNotifications();
  }

  ///
  /// METHODS
  ///

  /// Triggered when a notification is received on `iOS`
  Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    try {
      // TODO: Needs to be implemented

      logger.f('onDidReceiveLocalNotification() triggered');
    } catch (e) {
      final error = 'NotificationService -> onDidReceiveLocalNotification() -> $e';
      logger.e(error);
    }
  }

  Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    try {
      // TODO: Needs to be implemented

      logger.f('onDidReceiveNotificationResponse() triggered');
    } catch (e) {
      final error = 'NotificationService -> onDidReceiveNotificationResponse() -> $e';
      logger.e(error);
    }
  }

  /// Configures timezone, required for scheduled notifications
  Future<void> configureTimeZone() async {
    try {
      if (kIsWeb || Platform.isLinux) {
        return;
      }

      tz.initializeTimeZones();
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      final error = 'NotificationService -> configureTimeZone() -> $e';
      logger.e(error);
    }
  }

  /// Initializes [FlutterLocalNotifications] plugin
  Future<bool> initializeNotifications() async {
    try {
      /// `Android`
      const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

      /// `iOS`
      final initializationSettingsDarwin = DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );

      /// `Linux`
      final initializationSettingsLinux = LinuxInitializationSettings(
        defaultActionName: 'Promaja',
        defaultIcon: AssetsLinuxIcon(PromajaIcons.icon),
      );

      /// Initialization settings
      final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux,
      );

      final initialized = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
      );

      return initialized ?? false;
    } catch (e) {
      final error = 'NotificationService -> initializeNotifications() -> $e';
      logger.e(error);
      return false;
    }
  }

  /// Triggers notification permission dialog
  Future<bool> requestNotificationPermissions() async {
    try {
      bool? permissionsGranted;

      /// `Android` notifications
      if (Platform.isAndroid) {
        permissionsGranted =
            await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ?? false;

        if (!permissionsGranted) {
          permissionsGranted =
              await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission() ?? false;
        }
      }

      /// `iOS` notifications
      if (Platform.isIOS) {
        permissionsGranted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
                  alert: true,
                  badge: true,
                ) ??
            false;
      }

      /// `MacOS` notifications
      if (Platform.isMacOS) {
        permissionsGranted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
                  alert: true,
                  badge: true,
                ) ??
            false;
      }

      /// Error while granting permissions
      if (permissionsGranted == null) {
        const error = 'NotificationService -> requestNotificationPermissions() -> Platform different than Android, iOS or MacOS';
        logger.e(error);
        return false;
      }

      return permissionsGranted;
    } catch (e) {
      final error = 'NotificationService -> requestNotificationPermissions() -> $e';
      logger.e(error);
      return false;
    }
  }

  /// Cancels all notifications
  Future<void> cancelNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      final error = 'NotificationService -> cancelNotifications() -> $e';
      logger.e(error);
    }
  }

  /// Shows a notification
  Future<void> showNotification({required String title, required String text}) async {
    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        text,
        notificationDetails,
        payload: 'promaja_payload',
      );
    } catch (e) {
      final error = 'NotificationService -> showNotification() -> $e';
      logger.e(error);
    }
  }

  /// Shows notification with weather data
  Future<void> showWeatherNotification({required ResponseCurrentWeather response}) async {
    try {
      /// Store relevant values in variables
      final locationName = response.location.name;

      final currentWeather = response.current;

      final temp = currentWeather.tempC.round();
      final conditionCode = currentWeather.condition.code;
      final isDay = currentWeather.isDay == 1;

      final weatherDescription = getWeatherDescription(
        code: conditionCode,
        isDay: isDay,
      );

      final text = "It's ${weatherDescription.toLowerCase()} with a temperature of $temp°C in $locationName.";

      await showNotification(title: 'Promaja', text: text);
    } catch (e) {
      final error = 'NotificationService -> scheduleDailyNotification() -> $e';
      logger.e(error);
    }
  }

  /// Shows a test notification
  Future<void> testNotification() async {
    try {
      final permissionsGranted = await requestNotificationPermissions();
      if (permissionsGranted) {
        await cancelNotifications();
        await showNotification(
          title: 'Promaja',
          text: getRandomJoke(),
        );
      }
    } catch (e) {
      final error = 'NotificationService -> testNotification() -> $e';
      logger.e(error);
    }
  }
}

/// Returns a random weather joke
String getRandomJoke() {
  final random = Random();
  final index = random.nextInt(15);
  return 'weatherJoke$index'.tr();
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print('notification action tapped with input: ${notificationResponse.input}');
  }
}
