import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/icons.dart';
import '../models/current_weather/response_current_weather.dart';
import '../models/forecast_weather/response_forecast_weather.dart';
import '../models/settings/promaja_settings.dart';
import '../models/settings/units/temperature_unit.dart';
import '../util/weather.dart';
import 'api_service.dart';
import 'hive_service.dart';
import 'logger_service.dart';

///
/// Service which initializes `Notifications`
/// Used for showing notifications on the phone
///

final notificationProvider = Provider<NotificationService>(
  (ref) => NotificationService(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'NotificationProvider',
);

class NotificationService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  NotificationService({
    required this.logger,
    required this.hive,
  });

  ///
  /// VARIABLES
  ///

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

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
    final settings = hive.getPromajaSettingsFromBox();

    /// Notifications are not initialized & they are enabled in settings
    if (flutterLocalNotificationsPlugin == null &&
        (settings.notification.hourlyNotification || settings.notification.morningNotification || settings.notification.eveningNotification)) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await configureTimeZone();
      await initializeNotifications();
    }
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

      final initialized = await flutterLocalNotificationsPlugin?.initialize(
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
            await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ?? false;

        if (!permissionsGranted) {
          permissionsGranted =
              await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission() ?? false;
        }
      }

      /// `iOS` notifications
      if (Platform.isIOS) {
        permissionsGranted = await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
                  alert: true,
                  badge: true,
                ) ??
            false;
      }

      /// `MacOS` notifications
      if (Platform.isMacOS) {
        permissionsGranted = await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
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
      await flutterLocalNotificationsPlugin?.cancelAll();
    } catch (e) {
      final error = 'NotificationService -> cancelNotifications() -> $e';
      logger.e(error);
    }
  }

  /// Shows a notification
  Future<void> showNotification({required String title, required String text}) async {
    try {
      await flutterLocalNotificationsPlugin?.show(
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

  /// Shows a test notification
  Future<void> testNotification() async {
    try {
      /// Initialize notifications if they're not initialized
      if (flutterLocalNotificationsPlugin == null) {
        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        await configureTimeZone();
        await initializeNotifications();
      }

      /// Check permissions
      final permissionsGranted = await requestNotificationPermissions();

      if (permissionsGranted) {
        /// Show notification
        await showNotification(
          title: 'Promaja',
          text: getRandomWeatherJoke(),
        );
      }
    } catch (e) {
      final error = 'NotificationService -> testNotification() -> $e';
      logger.e(error);
    }
  }

  /// Returns a random weather joke
  String getRandomWeatherJoke() {
    final random = Random();
    final index = random.nextInt(15);
    return 'weatherJoke${index + 1}'.tr();
  }

  /// Handles notification logic, depending on `NotificationSettings`
  Future<void> handleNotifications({
    required PromajaSettings settings,
    required ProviderContainer container,
  }) async {
    try {
      final location = settings.notification.location;

      /// Location exists
      if (location != null) {
        /// Hourly notification is active, fetch current weather and show it
        if (settings.notification.hourlyNotification) {
          final currentWeather = await container.read(apiProvider).fetchCurrentWeather(
                location: location,
                container: container,
              );

          /// Current weather is successfully fetched
          if (currentWeather != null) {
            await triggerHourlyNotification(
              currentWeather: currentWeather,
              showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
              container: container,
            );
          }
        }

        /// Morning notification is active, fetch today's forecast and show it
        if (settings.notification.morningNotification) {
          // TODO: Logic which checks if this was ran already this morning

          final forecastWeather = await container.read(apiProvider).fetchForecastWeather(
                location: location,
                isTomorrow: false,
                container: container,
              );

          /// Forecast weather is successfully fetched
          if (forecastWeather != null) {
            await triggerForecastNotification(
              forecastWeather: forecastWeather,
              showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
              isTomorrow: false,
              container: container,
            );
          }
        }

        /// Evening notification is active, fetch tomorrow's forecast and show it
        if (settings.notification.eveningNotification) {
          // TODO: Logic which checks if this was ran already this evening

          final forecastWeather = await container.read(apiProvider).fetchForecastWeather(
                location: location,
                isTomorrow: true,
                container: container,
              );

          /// Forecast weather is successfully fetched
          if (forecastWeather != null) {
            await triggerForecastNotification(
              forecastWeather: forecastWeather,
              showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
              isTomorrow: true,
              container: container,
            );
          }
        }
      }
    } catch (e) {
      final error = 'handleNotifications -> $e';
      Logger().e(error);
    }
  }

  /// Triggers hourly notification with proper data
  Future<void> triggerHourlyNotification({
    required ResponseCurrentWeather currentWeather,
    required bool showCelsius,
    required ProviderContainer container,
  }) async {
    try {
      /// Store relevant values in variables
      final locationName = currentWeather.location.name;

      final temp = showCelsius ? '${currentWeather.current.tempC.round()}°C' : '${currentWeather.current.tempF.round()}°F';

      final weatherDescription = getWeatherDescription(
        code: currentWeather.current.condition.code,
        isDay: currentWeather.current.isDay == 1,
      );

      final timestamp = DateFormat.Hm().format(DateTime.now());

      final title = 'Hourly notification @ $timestamp';
      final text = 'Hello! Current weather in $locationName is ${weatherDescription.toLowerCase()} with a temperature of $temp.';

      await container.read(notificationProvider).showNotification(title: title, text: text);
    } catch (e) {
      final error = 'triggerHourlyNotification -> $e';
      Logger().e(error);
    }
  }

  /// Triggers forecast notification with proper data
  Future<void> triggerForecastNotification({
    required ResponseForecastWeather forecastWeather,
    required bool showCelsius,
    required bool isTomorrow,
    required ProviderContainer container,
  }) async {
    try {
      /// Store relevant values in variables
      final locationName = forecastWeather.location.name;

      final time = DateTime.now().add(
        isTomorrow ? const Duration(days: 1) : Duration.zero,
      );
      final forecast = forecastWeather.forecast.forecastDays
          .where(
            (forecastDay) => forecastDay.dateEpoch.year == time.year && forecastDay.dateEpoch.month == time.month && forecastDay.dateEpoch.day == time.day,
          )
          .toList()
          .firstOrNull;

      /// Forecast exists, show it
      if (forecast != null) {
        final minTemp = showCelsius ? '${forecast.day.minTempC.round()}°C' : '${forecast.day.minTempF.round()}°F';
        final maxTemp = showCelsius ? '${forecast.day.maxTempC.round()}°C' : '${forecast.day.maxTempF.round()}°F';

        final weatherDescription = getWeatherDescription(
          code: forecast.day.condition.code,
          isDay: true,
        );

        final timestamp = DateFormat.Hm().format(DateTime.now());

        final partOfDay = isTomorrow ? 'Evening' : 'Morning';
        final whichDay = isTomorrow ? 'Tomorrow' : 'Today';

        final title = '$partOfDay notification @ $timestamp';
        final text =
            'Good ${partOfDay.toLowerCase()}! $whichDay the weather in $locationName will be ${weatherDescription.toLowerCase()} with a temperature between $minTemp and $maxTemp.';

        await showNotification(title: title, text: text);
      }
    } catch (e) {
      final error = 'triggerMorningNotification -> $e';
      Logger().e(error);
    }
  }
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  // TODO: Needs to be implemented
}
