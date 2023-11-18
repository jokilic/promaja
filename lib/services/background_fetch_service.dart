import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../screens/cards/cards_notifiers.dart';
import '../screens/weather/weather_notifiers.dart';
import 'hive_service.dart';
import 'home_widget_service.dart';
import 'logger_service.dart';

///
/// Initializes `BackgroundFetch`
/// Used for scheduling tasks
///

final backgroundFetchInitializeProvider = FutureProvider<void>(
  (ref) async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 60,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
      ),

      /// Runs when background event is triggered
      (taskId) async {
        await fetchWeatherAndUpdateHomeWidget();
        BackgroundFetch.finish(taskId);
      },

      /// Runs when task timeout has occured
      (taskId) async {
        final error = 'backgroundFetchInitializeProvider -> Task timeout -> taskId - $taskId';
        ref.read(loggerProvider).e(error);
        BackgroundFetch.finish(taskId);
      },
    );

    await BackgroundFetch.start();
  },
  name: 'BackgroundFetchInitializeProvider',
);

/// Headless task which is run on Android when the app is terminated
@pragma('vm:entry-point')
Future<void> backgroundFetchHeadlessTask(HeadlessTask task) async {
  final taskId = task.taskId;
  final isTimeout = task.timeout;

  /// This task has exceeded its allowed running-time, finish task
  if (isTimeout) {
    const error = "backgroundFetchHeadlessTask -> task has exceeded it's allowed running-time";
    Logger().e(error);
    BackgroundFetch.finish(taskId);
    return;
  }

  /// Start working on the task
  Logger().i('backgroundFetchHeadlessTask -> headless event received');
  await fetchWeatherAndUpdateHomeWidget();
  BackgroundFetch.finish(taskId);
}

/// Logic to fetch weather and update active [HomeWidget]
Future<void> fetchWeatherAndUpdateHomeWidget() async {
  Logger().f('[BACKGROUND] Running task');

  try {
    /// Initialize services
    final container = ProviderContainer();
    final logger = container.read(loggerProvider);
    final hive = container.read(hiveProvider.notifier);
    await hive.init();

    logger.f('[BACKGROUND] Initialized services');

    /// Get location to fetch
    final location = container.read(activeWeatherProvider);

    /// Location exists, fetch data
    if (location != null) {
      logger.f('[BACKGROUND] Location not null');

      final response = await container.read(getCurrentWeatherProvider(location).future);

      /// Data fetch was successful, update [HomeWidget]
      if (response.response != null && response.error == null) {
        logger.f('[BACKGROUND] Response successful');

        await container.read(updateHomeWidgetProvider(response.response!).future);

        logger.f('[BACKGROUND] HomeWidget updated');

        return Future.value(true);
      }

      /// Data fetch wasn't successfull, throw error
      else {
        const error = "fetchWeatherAndUpdateHomeWidget -> data fetch wasn't successful";
        logger.e(error);
        return Future.error(error);
      }
    }

    /// Location doesn't exist, throw error
    else {
      const error = "fetchWeatherAndUpdateHomeWidget -> location doesn't exist";
      logger.e(error);
      return Future.error(error);
    }
  }

  /// Some generic error happened, throw error
  catch (e) {
    final error = 'fetchWeatherAndUpdateHomeWidget -> $e';
    Logger().e(error);
    return Future.error(error);
  }
}
