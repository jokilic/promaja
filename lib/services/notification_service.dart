import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../constants/icons.dart';
import '../models/current_weather/response_current_weather.dart';
import '../models/forecast_weather/response_forecast_weather.dart';
import '../models/settings/notification/notification_type.dart';
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

  var notificationId = 0;

  ///
  /// INIT
  ///

  Future<void> init() async {
    final settings = hive.getPromajaSettingsFromBox();

    /// Notifications are not initialized & they are enabled in settings
    if (flutterLocalNotificationsPlugin == null &&
        (settings.notification.hourlyNotification || settings.notification.morningNotification || settings.notification.eveningNotification)) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await initializeNotifications();
    }
  }

  ///
  /// METHODS
  ///

  /// Triggered when a notification is received while the app is in foreground on `iOS`
  Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    try {
      // TODO: Implement this

      final value = 'onDidReceiveLocalNotification -> payload -> $payload';

      Logger().f(value);
      dev.log(value);
      print(value);
    } catch (e) {
      final error = 'NotificationService -> onDidReceiveLocalNotification() -> $e';
      logger.e(error);
    }
  }

  /// Triggered when the user taps the notification
  Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    try {
      // TODO: Implement this

      final payload = notificationResponse.payload;
      final value = 'onDidReceiveNotificationResponse -> payload -> $payload';

      Logger().f(value);
      dev.log(value);
      print(value);
    } catch (e) {
      final error = 'NotificationService -> onDidReceiveNotificationResponse() -> $e';
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
  Future<void> showNotification({
    required String title,
    required String text,
    required NotificationType notificationType,
  }) async {
    try {
      final bigTextStyleInformation = BigTextStyleInformation(
        text,
        contentTitle: title,
      );

      final androidNotificationDetails = AndroidNotificationDetails(
        'promaja_channel_id',
        'Promaja notifications',
        channelDescription: 'Notifications shown by the Promaja app',
        styleInformation: bigTextStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const iosNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: 'promaja_category_id',
      );

      const macOSNotificationDetails = DarwinNotificationDetails(
        categoryIdentifier: 'promaja_category_id',
      );

      const linuxNotificationDetails = LinuxNotificationDetails();

      final notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
        macOS: macOSNotificationDetails,
        linux: linuxNotificationDetails,
      );

      await flutterLocalNotificationsPlugin?.show(
        notificationId++,
        title,
        text,
        notificationDetails,
        payload: notificationType.name,
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
        await initializeNotifications();
      }

      /// Check permissions
      final permissionsGranted = await requestNotificationPermissions();

      if (permissionsGranted) {
        /// Show notification
        await showNotification(
          title: 'Test notification',
          text: getRandomWeatherJoke(),
          notificationType: NotificationType.test,
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

        /// Morning notification is active
        if (settings.notification.morningNotification) {
          /// Check if notification should be triggered
          final shouldShowNotification = shouldTriggerNotification(
            isEveningNotification: false,
          );

          /// Notification should be shown
          if (shouldShowNotification) {
            /// Fetch today's forecast
            final forecastWeather = await container.read(apiProvider).fetchForecastWeather(
                  location: location,
                  isTomorrow: false,
                  container: container,
                );

            /// Forecast weather is successfully fetched
            if (forecastWeather != null) {
              /// Show notification
              await triggerForecastNotification(
                forecastWeather: forecastWeather,
                showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
                isEvening: false,
                container: container,
              );
            }
          }
        }

        /// Evening notification is active
        if (settings.notification.eveningNotification) {
          /// Check if notification should be triggered
          final shouldShowNotification = shouldTriggerNotification(
            isEveningNotification: true,
          );

          /// Notification should be shown
          if (shouldShowNotification) {
            /// Fetch tomorrow's forecast
            final forecastWeather = await container.read(apiProvider).fetchForecastWeather(
                  location: location,
                  isTomorrow: true,
                  container: container,
                );

            /// Forecast weather is successfully fetched
            if (forecastWeather != null) {
              /// Show notification
              await triggerForecastNotification(
                forecastWeather: forecastWeather,
                showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
                isEvening: true,
                container: container,
              );
            }
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

      const title = 'Hourly notification';
      final text = 'Hello! Current weather in $locationName is ${weatherDescription.toLowerCase()} with a temperature of $temp.';

      await container.read(notificationProvider).showNotification(
            title: title,
            text: text,
            notificationType: NotificationType.hourly,
          );
    } catch (e) {
      final error = 'triggerHourlyNotification -> $e';
      Logger().e(error);
    }
  }

  /// Triggers forecast notification with proper data
  Future<void> triggerForecastNotification({
    required ResponseForecastWeather forecastWeather,
    required bool showCelsius,
    required bool isEvening,
    required ProviderContainer container,
  }) async {
    try {
      /// Store relevant values in variables
      final locationName = forecastWeather.location.name;

      final time = DateTime.now().add(
        isEvening ? const Duration(days: 1) : Duration.zero,
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

        final partOfDay = isEvening ? 'Evening' : 'Morning';
        final whichDay = isEvening ? 'Tomorrow' : 'Today';

        final title = '$partOfDay notification';
        final text =
            'Good ${partOfDay.toLowerCase()}! $whichDay the weather in $locationName will be ${weatherDescription.toLowerCase()} with a temperature between $minTemp and $maxTemp.';

        await showNotification(
          title: title,
          text: text,
          notificationType: isEvening ? NotificationType.evening : NotificationType.morning,
        );
      }
    } catch (e) {
      final error = 'triggerMorningNotification -> $e';
      Logger().e(error);
    }
  }

  /// Checks when last notification was triggered and returns `true` if it's more than 20 hours
  bool shouldTriggerNotification({required bool isEveningNotification}) {
    final now = DateTime.now();

    final startHour = isEveningNotification ? 19 : 8;
    final endHour = isEveningNotification ? 21 : 10;

    /// Notification is triggered between `startHour` & `endHour`
    if (now.hour >= startHour && now.hour <= endHour) {
      /// Get [DateTime] when the last notification is triggered
      final lastShownNotification = hive.getNotificationLastShownFromBox();
      final lastShownNotificationDateTime = (isEveningNotification ? lastShownNotification?.eveningNotificationLastShown : lastShownNotification?.morningNotificationLastShown) ??
          DateTime.fromMillisecondsSinceEpoch(0);

      /// Calculate difference between the last notification and current time
      final difference = now.difference(lastShownNotificationDateTime);

      /// The difference is more than 20 hours, we should trigger the notification
      return difference.inHours > 20;
    }
    return false;
  }
}

/// Triggered when a notification is received while the app is terminated
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  // TODO: Implement this

  final payload = notificationResponse.payload;
  final value = 'onDidReceiveBackgroundNotificationResponse -> payload -> $payload';

  Logger().f(value);
  dev.log(value);
  print(value);
}
