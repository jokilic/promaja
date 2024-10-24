import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../constants/durations.dart';
import '../constants/icons.dart';
import '../main.dart';
import '../models/current_weather/response_current_weather.dart';
import '../models/location/location.dart';
import '../models/notification_payload/notification_payload.dart';
import '../models/settings/notification/notification_last_shown.dart';
import '../models/settings/notification/notification_type.dart';
import '../models/settings/units/temperature_unit.dart';
import '../models/weather/response_forecast_weather.dart';
import '../screens/cards/cards_notifiers.dart';
import '../util/initialization.dart';
import '../util/weather.dart';
import '../widgets/promaja_navigation_bar.dart';
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
    api: ref.watch(apiProvider),
    ref: ref,
  ),
  name: 'NotificationProvider',
);

class NotificationService {
  final LoggerService logger;
  final HiveService hive;
  final APIService api;
  final ProviderRef ref;

  NotificationService({
    required this.logger,
    required this.hive,
    required this.api,
    required this.ref,
  });

  ///
  /// VARIABLES
  ///

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

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
      await requestNotificationPermissions();
    }
  }

  ///
  /// METHODS
  ///

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
      final error = 'InitializeNotifications -> catch -> $e';
      unawaited(Sentry.captureException(error));
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
        const error = 'RequestNotificationPermissions -> Notification platform different than Android, iOS or MacOS';
        unawaited(Sentry.captureException(error));
        logger.e(error);
        return false;
      }

      if (!permissionsGranted) {
        const error = 'RequestNotificationPermissions -> Notification permissions denied';
        unawaited(Sentry.captureException(error));
        logger.e(error);
      }

      return permissionsGranted;
    } catch (e) {
      final error = 'RequestNotificationPermissions -> catch -> $e';
      unawaited(Sentry.captureException(error));
      logger.e(error);

      return false;
    }
  }

  /// Cancels all notifications
  Future<void> cancelNotifications() async {
    try {
      await flutterLocalNotificationsPlugin?.cancelAll();
    } catch (e) {
      final error = 'CancelNotifications -> catch -> $e';
      unawaited(Sentry.captureException(error));
      logger.e(error);
    }
  }

  /// Shows a notification
  Future<void> showNotification({
    required String title,
    required String text,
    required NotificationType notificationType,
    Location? location,
  }) async {
    try {
      final bigTextStyleInformation = BigTextStyleInformation(
        text,
        contentTitle: title,
        htmlFormatBigText: true,
        htmlFormatContent: true,
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

      final payload = NotificationPayload(
        location: location,
        notificationType: notificationType,
      ).toJson();

      await flutterLocalNotificationsPlugin?.show(
        notificationType.index,
        title,
        text,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      final error = 'ShowNotification -> catch -> $e';
      unawaited(Sentry.captureException(error));
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
          title: 'testNotificationTitle'.tr(),
          text: getRandomWeatherJoke(),
          notificationType: NotificationType.test,
        );
      }
    } catch (e) {
      final error = 'TestNotification -> catch -> $e';
      unawaited(Sentry.captureException(error));
      logger.e(error);
    }
  }

  /// Returns a random weather joke
  String getRandomWeatherJoke() {
    final random = Random();
    final index = random.nextInt(50);
    return 'weatherJoke${index + 1}'.tr();
  }

  /// Handles notification logic, depending on `NotificationSettings`
  Future<void> handleNotifications() async {
    try {
      final settings = hive.getPromajaSettingsFromBox();

      final location = settings.notification.location;

      /// Location exists
      if (location != null) {
        ///
        /// Hourly notification is active, fetch current weather and show it
        ///
        if (settings.notification.hourlyNotification) {
          /// Fetch current weather
          final currentWeather = await api.fetchCurrentWeather(
            location: location,
          );

          /// Current weather is successfully fetched
          if (currentWeather != null) {
            await triggerHourlyNotification(
              currentWeather: currentWeather,
              showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
              location: location,
            );
          }
        }

        ///
        /// Morning notification is active
        ///
        if (settings.notification.morningNotification) {
          /// Check if notification should be triggered
          final shouldShowNotification = shouldTriggerNotification(
            isEveningNotification: false,
          );

          /// Notification should be shown
          if (shouldShowNotification) {
            /// Fetch today's forecast
            final forecastWeather = await api.fetchForecastWeather(
              location: location,
              isTomorrow: false,
            );

            /// Forecast weather is successfully fetched
            if (forecastWeather != null) {
              /// Show notification
              await triggerForecastNotification(
                forecastWeather: forecastWeather,
                showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
                isEvening: false,
                location: location,
              );

              /// Store new value of `NotificationLastShown` in [Hive]
              final oldNotificationLastShown = hive.getNotificationLastShownFromBox();

              final newNotificationLastShown = NotificationLastShown(
                morningNotificationLastShown: DateTime.now(),
                eveningNotificationLastShown: oldNotificationLastShown?.eveningNotificationLastShown ?? DateTime.fromMillisecondsSinceEpoch(0),
              );

              await hive.addNotificationLastShownToBox(
                notificationLastShown: newNotificationLastShown,
              );
            }
          }
        }

        ///
        /// Evening notification is active
        ///
        if (settings.notification.eveningNotification) {
          /// Check if notification should be triggered
          final shouldShowNotification = shouldTriggerNotification(
            isEveningNotification: true,
          );

          /// Notification should be shown
          if (shouldShowNotification) {
            /// Fetch tomorrow's forecast
            final forecastWeather = await api.fetchForecastWeather(
              location: location,
              isTomorrow: true,
            );

            /// Forecast weather is successfully fetched
            if (forecastWeather != null) {
              /// Show notification
              await triggerForecastNotification(
                forecastWeather: forecastWeather,
                showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
                isEvening: true,
                location: location,
              );

              /// Store new value of `NotificationLastShown` in [Hive]
              final oldNotificationLastShown = hive.getNotificationLastShownFromBox();

              final newNotificationLastShown = NotificationLastShown(
                morningNotificationLastShown: oldNotificationLastShown?.morningNotificationLastShown ?? DateTime.fromMillisecondsSinceEpoch(0),
                eveningNotificationLastShown: DateTime.now(),
              );

              await hive.addNotificationLastShownToBox(
                notificationLastShown: newNotificationLastShown,
              );
            }
          }
        }
      }

      /// Location doesn't exist
      else {
        const error = 'HandleNotifications -> Location is null';
        unawaited(Sentry.captureException(error));
        logger.e(error);
      }
    } catch (e) {
      final error = 'HandleNotifications -> catch -> $e';
      unawaited(Sentry.captureException(error));
      logger.e(error);
    }
  }

  /// Triggers hourly notification with proper data
  Future<void> triggerHourlyNotification({
    required ResponseCurrentWeather currentWeather,
    required bool showCelsius,
    required Location location,
  }) async {
    try {
      /// Store relevant values in variables
      final locationName = currentWeather.location.name;

      final temp = showCelsius ? '${currentWeather.current.tempC.round()}°C' : '${currentWeather.current.tempF.round()}°F';

      final weatherDescription = getWeatherDescription(
        code: currentWeather.current.condition.code,
        isDay: currentWeather.current.isDay == 1,
      );

      final title = 'hourlyNotificationTitle'.tr();

      final text = 'hourlyNotificationText'.tr(
        args: Platform.isAndroid
            ? [
                '<b>$locationName</b>',
                '<b>${weatherDescription.toLowerCase()}</b>',
                '<b>$temp</b>',
              ]
            : [
                locationName,
                weatherDescription.toLowerCase(),
                temp,
              ],
      );

      await showNotification(
        title: title,
        text: text,
        notificationType: NotificationType.hourly,
        location: location,
      );
    } catch (e) {
      final error = 'TriggerHourlyNotification -> catch -> $e';
      unawaited(Sentry.captureException(error));
      logger.e(error);
    }
  }

  /// Triggers forecast notification with proper data
  Future<void> triggerForecastNotification({
    required ResponseForecastWeather forecastWeather,
    required bool showCelsius,
    required bool isEvening,
    required Location location,
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

        final title = isEvening ? 'eveningNotificationTitle'.tr() : 'morningNotificationTitle'.tr();

        final text = isEvening
            ? 'eveningNotificationText'.tr(
                args: Platform.isAndroid
                    ? [
                        '<b>$locationName</b>',
                        '<b>${weatherDescription.toLowerCase()}</b>',
                        '<b>$minTemp</b>',
                        '<b>$maxTemp</b>',
                      ]
                    : [
                        locationName,
                        weatherDescription.toLowerCase(),
                        minTemp,
                        maxTemp,
                      ],
              )
            : 'morningNotificationText'.tr(
                args: Platform.isAndroid
                    ? [
                        '<b>$locationName</b>',
                        '<b>${weatherDescription.toLowerCase()}</b>',
                        '<b>$minTemp</b>',
                        '<b>$maxTemp</b>',
                      ]
                    : [
                        locationName,
                        weatherDescription.toLowerCase(),
                        minTemp,
                        maxTemp,
                      ],
              );

        await showNotification(
          title: title,
          text: text,
          notificationType: isEvening ? NotificationType.evening : NotificationType.morning,
          location: location,
        );
      }
    } catch (e) {
      final error = 'TriggerForecastNotification -> ${isEvening ? 'Evening' : 'Morning'} notification -> catch -> $e';
      unawaited(Sentry.captureException(error));
      logger.e(error);

      logger.e('${isEvening ? 'Evening' : 'Morning'} notification -> $e');
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

  /// Triggered when user presses a notification
  Future<void> handlePressedNotification({required String? payload}) async {
    try {
      final context = navigatorKey.currentState?.context;

      if (payload != null && context != null) {
        /// Parse to `NotificationPayload`
        final notificationPayload = NotificationPayload.fromJson(payload);

        /// Navigate to base route
        Navigator.of(context).popUntil((route) => route.isFirst);

        switch (notificationPayload.notificationType) {
          ///
          /// Hourly notification
          ///
          case NotificationType.hourly:
            if (notificationPayload.location != null) {
              /// Get location index
              final locationIndex = ref.read(hiveProvider).indexOf(notificationPayload.location!);

              /// Go to `CardsScreen` with proper location
              ref.read(cardMovingProvider.notifier).state = false;
              ref.read(cardIndexProvider.notifier).state = locationIndex;
              if (ref.read(cardAdditionalControllerProvider).hasClients) {
                ref.read(cardAdditionalControllerProvider).jumpTo(0);
              }
              await ref.read(navigationBarIndexProvider.notifier).changeNavigationBarIndex(NavigationBarItems.cards.index);
              await Future.delayed(PromajaDurations.cardsSwiperNotificationDelay);
              for (var i = 0; i < locationIndex; i++) {
                await ref.read(cardsAppinioControllerProvider).swipeDefault();
              }
            }

          ///
          /// Morning / evening notification
          ///
          case NotificationType.morning:
          case NotificationType.evening:
            if (notificationPayload.location != null) {
              /// Get location index
              final locationIndex = ref.read(hiveProvider).indexOf(notificationPayload.location!);

              /// Go to `ForecastScreen` with proper location
              await ref.read(hiveProvider.notifier).addActiveLocationIndexToBox(index: locationIndex);
              await ref.read(navigationBarIndexProvider.notifier).changeNavigationBarIndex(NavigationBarItems.weather.index);
            }

          ///
          /// Test notification
          ///
          case NotificationType.test:
            logger.f('Hello testy test');
        }
      }

      /// Payload or context is null
      else {
        const error = 'HandlePressedNotification -> Payload or context is null';
        unawaited(Sentry.captureException(error));
        logger.e(error);
      }
    } catch (e) {
      final error = 'HandlePressedNotification -> catch -> $e';
      unawaited(Sentry.captureException(error));
      logger.e(error);
    }
  }

  /// Triggered when a notification is received while the app is in foreground on `iOS`
  Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    try {
      await handlePressedNotification(payload: payload);
    } catch (e) {
      final error = 'OnDidReceiveLocalNotification -> catch -> $e';
      unawaited(Sentry.captureException(error));
      logger.e(error);
    }
  }

  /// Triggered when the user taps the notification
  Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    try {
      await handlePressedNotification(
        payload: notificationResponse.payload,
      );
    } catch (e) {
      final error = 'onDidReceiveNotificationResponse -> catch -> $e';
      unawaited(Sentry.captureException(error));
      logger.e(error);
    }
  }
}

/// Triggered when a notification is received while the app is terminated
@pragma('vm:entry-point')
Future<void> onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
  try {
    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    /// Initialize [EasyLocalization]
    await initializeLocalization();

    /// Initialize services
    final container = await initializeServices();

    if (container != null) {
      await container.read(notificationProvider).handlePressedNotification(
            payload: notificationResponse.payload,
          );
    }
  } catch (e) {
    final logger = LoggerService();
    final hive = HiveService(logger);
    await hive.init();
  }
}
