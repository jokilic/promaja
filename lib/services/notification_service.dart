import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/durations.dart';
import '../main.dart';
import '../models/current_weather/response_current_weather.dart';
import '../models/location/location.dart';
import '../models/notification_payload/notification_payload.dart';
import '../models/settings/appearance/weather_card_layout.dart';
import '../models/settings/notification/notification_last_shown.dart';
import '../models/settings/notification/notification_type.dart';
import '../models/settings/units/temperature_unit.dart';
import '../models/weather/response_forecast_weather.dart';
import '../screens/current/current_controller.dart';
import '../util/dependencies.dart';
import '../util/weather.dart';
import 'api_service.dart';
import 'hive_service.dart';
import 'location_service.dart';
import 'screen_service.dart';

class NotificationService {
  final HiveService hive;
  final APIService api;
  final LocationService location;

  NotificationService({
    required this.hive,
    required this.api,
    required this.location,
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
      const initializationSettingsDarwin = DarwinInitializationSettings();

      /// Initialization settings
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
      );

      final initialized = await flutterLocalNotificationsPlugin?.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
      );

      return initialized ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Triggers notification permission dialog
  Future<bool> requestNotificationPermissions() async {
    try {
      bool? permissionsGranted;

      /// `Android` notifications
      if (defaultTargetPlatform == TargetPlatform.android) {
        permissionsGranted =
            await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ?? false;

        if (!permissionsGranted) {
          permissionsGranted =
              await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission() ?? false;
        }
      }

      /// `iOS` notifications
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        permissionsGranted =
            await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
              alert: true,
              badge: true,
            ) ??
            false;
      }

      /// `MacOS` notifications
      if (defaultTargetPlatform == TargetPlatform.macOS) {
        permissionsGranted =
            await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
              alert: true,
              badge: true,
            ) ??
            false;
      }

      /// Error while granting permissions
      if (permissionsGranted == null) {
        return false;
      }

      if (!permissionsGranted) {}

      return permissionsGranted;
    } catch (e) {
      return false;
    }
  }

  /// Cancels all notifications
  Future<void> cancelNotifications() async {
    try {
      await flutterLocalNotificationsPlugin?.cancelAll();
    } catch (_) {}
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

      final notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
        macOS: macOSNotificationDetails,
      );

      final payload = NotificationPayload(
        location: location,
        notificationType: notificationType,
      ).toJson();

      await flutterLocalNotificationsPlugin?.show(
        id: notificationType.index,
        title: title,
        body: text,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (_) {}
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
    } catch (_) {}
  }

  /// Returns a random weather joke
  String getRandomWeatherJoke() {
    final random = math.Random();
    final index = random.nextInt(50);
    return 'weatherJoke${index + 1}'.tr();
  }

  /// Handles notification logic, depending on `NotificationSettings`
  Future<void> handleNotifications() async {
    try {
      final settings = hive.getPromajaSettingsFromBox();

      var location = settings.notification.location;

      /// Location exists
      if (location != null) {
        /// Refresh coordinates before fetching weather for the phone location
        if (location.isPhoneLocation ?? false) {
          location = await refreshPhoneLocation(
            passedLocation: location,
          );
        }

        ///
        /// Hourly notification is active, fetch current weather and show it
        ///
        if (settings.notification.hourlyNotification) {
          /// Fetch current weather
          final currentWeather = await api.getCachedCurrentWeather(
            query: '${location.lat},${location.lon}',
          );

          /// Current weather is successfully fetched
          if (currentWeather.response != null) {
            await triggerHourlyNotification(
              currentWeather: currentWeather.response!,
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
            final forecastWeather = await api.getCachedForecastWeather(
              query: '${location.lat},${location.lon}',
              days: 1,
            );

            /// Forecast weather is successfully fetched
            if (forecastWeather.response != null) {
              /// Show notification
              await triggerForecastNotification(
                forecastWeather: forecastWeather.response!,
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
            final forecastWeather = await api.getCachedForecastWeather(
              query: '${location.lat},${location.lon}',
              days: 2,
            );

            /// Forecast weather is successfully fetched
            if (forecastWeather.response != null) {
              /// Show notification
              await triggerForecastNotification(
                forecastWeather: forecastWeather.response!,
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
    } catch (_) {}
  }

  /// Refreshes the stored phone location and returns the location to use for notifications
  Future<Location> refreshPhoneLocation({required Location passedLocation}) async {
    final position = await location.getPosition();

    /// Keep using the last stored position when GPS refresh fails
    if (position.position == null) {
      return passedLocation;
    }

    final refreshedLocation = passedLocation.copyWith(
      lat: position.position!.latitude,
      lon: position.position!.longitude,
    );

    final locations = hive.getLocationsFromBox();
    final phoneLocationIndex = locations.indexWhere(
      (location) => location.isPhoneLocation ?? false,
    );

    if (phoneLocationIndex != -1) {
      await hive.replaceLocationInBox(
        index: phoneLocationIndex,
        location: refreshedLocation,
      );
    }

    return refreshedLocation;
  }

  /// Finds a stored location for a notification payload
  int? getNotificationLocationIndex({
    required List<Location> locations,
    required Location payloadLocation,
  }) {
    if (payloadLocation.isPhoneLocation ?? false) {
      final phoneLocationIndex = locations.indexWhere(
        (location) => location.isPhoneLocation ?? false,
      );

      return phoneLocationIndex == -1 ? null : phoneLocationIndex;
    }

    final locationIndex = locations.indexOf(payloadLocation);

    if (locationIndex != -1) {
      return locationIndex;
    }

    /// Supports notifications created before `isPhoneLocation` was added to the payload
    final coordinateLocationIndex = locations.indexWhere(
      (location) => location.lat == payloadLocation.lat && location.lon == payloadLocation.lon,
    );

    return coordinateLocationIndex == -1 ? null : coordinateLocationIndex;
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

      final weatherDescription =
          getWeatherDescription(
            code: currentWeather.current.condition.code,
            isDay: currentWeather.current.isDay == 1,
          ) ??
          '';

      final title = 'hourlyNotificationTitle'.tr();

      final text = 'hourlyNotificationText'.tr(
        args: defaultTargetPlatform == TargetPlatform.android
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
    } catch (_) {}
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

        final weatherDescription =
            getWeatherDescription(
              code: forecast.day.condition.code,
              isDay: true,
            ) ??
            '';

        final title = isEvening ? 'eveningNotificationTitle'.tr() : 'morningNotificationTitle'.tr();

        final text = isEvening
            ? 'eveningNotificationText'.tr(
                args: defaultTargetPlatform == TargetPlatform.android
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
                args: defaultTargetPlatform == TargetPlatform.android
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
    } catch (_) {}
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
      final lastShownNotificationDateTime =
          (isEveningNotification ? lastShownNotification?.eveningNotificationLastShown : lastShownNotification?.morningNotificationLastShown) ??
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

        /// Get currently stored `locations`
        final locations = hive.getLocationsFromBox();

        switch (notificationPayload.notificationType) {
          ///
          /// Hourly notification
          ///
          case NotificationType.hourly:
            if (notificationPayload.location != null) {
              /// Get location index
              final locationIndex = getNotificationLocationIndex(
                locations: locations,
                payloadLocation: notificationPayload.location!,
              );

              if (locationIndex == null) {
                return;
              }

              /// Get reference to `CurrentController`
              final current = getIt.get<CurrentController>()
                /// Update `state` in `CurrentController`
                ..updateState(
                  newIndex: locationIndex,
                );

              if (current.cardAdditionalPageController.hasClients) {
                current.cardAdditionalPageController.jumpTo(0);
              }

              await getIt.get<ScreenService>().changeNavigationBarItem(
                NavigationBarItem.current,
              );

              await Future.delayed(PromajaDurations.cardsSwiperNotificationDelay);

              final weatherCardLayout = hive.getPromajaSettingsFromBox().appearance.weatherCardLayout;

              switch (weatherCardLayout) {
                case WeatherCardLayout.stacked:
                  for (var i = 0; i < locationIndex; i++) {
                    current.cardSwiperController.swipe(CardSwiperDirection.right);
                    await Future.delayed(PromajaDurations.cardSwiperAnimation);
                  }
                case WeatherCardLayout.carousel:
                  await current.carouselController.animateToItem(
                    locationIndex,
                    duration: PromajaDurations.cardSwiperAnimation,
                  );
              }
            }

          ///
          /// Morning / evening notification
          ///
          case NotificationType.morning:
          case NotificationType.evening:
            if (notificationPayload.location != null) {
              /// Get location index
              final locationIndex = getNotificationLocationIndex(
                locations: locations,
                payloadLocation: notificationPayload.location!,
              );

              if (locationIndex == null) {
                return;
              }

              /// Go to `ForecastScreen` with proper location
              await hive.addActiveLocationIndexToBox(index: locationIndex);

              await getIt.get<ScreenService>().changeNavigationBarItem(
                NavigationBarItem.weather,
              );
            }

          ///
          /// Test notification
          ///
          case NotificationType.test:
        }
      }
    } catch (_) {}
  }

  /// Triggered when the user taps the notification
  Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    try {
      /// Trigger notification logic
      await handlePressedNotification(
        payload: notificationResponse.payload,
      );
    } catch (_) {}
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
    // The notification callback runs in a background isolate. Avoid enqueueing
    // BackgroundFetch while restoring the services needed to handle the tap.
    await initializeServices(
      initializeBackgroundFetch: false,
    );

    /// Trigger notification logic
    await getIt.get<NotificationService>().handlePressedNotification(
      payload: notificationResponse.payload,
    );
  } catch (_) {}
}
