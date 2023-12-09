import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'api_service.dart';
import 'dio_service.dart';
import 'hive_service.dart';
import 'home_widget_service.dart';
import 'logger_service.dart';

///
/// Initializes `BackgroundFetch`
/// Used for scheduling tasks
///

final backgroundFetchServiceInitializeProvider = FutureProvider<void>(
  (ref) async {
    /// Initialization of [BackgroundFetch]
    try {
      /// Register headless task
      await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

      /// Configure [BackgroundFetch]
      await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          startOnBoot: true,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ),

        /// Task logic
        (taskId) async {
          try {
            WidgetsFlutterBinding.ensureInitialized();
            DartPluginRegistrant.ensureInitialized();
            await EasyLocalization.ensureInitialized();

            /// Initialize services
            final logger = LoggerService();
            final hive = HiveService(logger);
            await hive.init();
            final dioService = DioService(logger);
            final api = APIService(
              logger: logger,
              dio: dioService.dio,
            );
            final homeWidget = HomeWidgetService(
              logger: logger,
              hive: hive,
            );

            /// Get location to fetch
            final weatherIndex = hive.getActiveLocationIndexFromBox();
            final weatherList = hive.getLocationsFromBox();
            final location = weatherList.isNotEmpty ? weatherList[weatherIndex] : null;

            /// Location exists, fetch data
            if (location != null) {
              final response = await api.getCurrentWeather(
                query: '${location.lat},${location.lon}',
              );

              /// Data fetch was successful, update [HomeWidget]
              if (response.response != null && response.error == null) {
                /// Get currently active location in [WeatherScreen]
                final activeLocationSameAsResponse = (location.lat == response.response!.location.lat) && (location.lon == response.response!.location.lon);

                /// Update [HomeWidget] if `activeLocation` is being fetched
                if (activeLocationSameAsResponse) {
                  /// Refresh [HomeWidget]

                  await homeWidget.refreshHomeWidget(
                    response: response.response!,
                  );
                }
              }

              /// Data fetch wasn't successfull, throw error
              else {
                const error = "backgroundFetchHeadlessTask -> data fetch wasn't successful";
                logger.e(error);
              }
            }

            /// Location doesn't exist, throw error
            else {
              const error = "backgroundFetchHeadlessTask -> location doesn't exist";
              logger.e(error);
            }
          }

          /// Some generic error happened, throw error
          catch (e) {
            final error = 'backgroundFetchHeadlessTask -> $e';
            Logger().e(error);
          }

          /// Finish task
          BackgroundFetch.finish(taskId);
        },

        /// Task timeout logic
        (taskId) async {
          Logger().e('Task timed-out: $taskId');
          BackgroundFetch.finish(taskId);
        },
      );

      /// Start [BackgroundFetch]
      await BackgroundFetch.start();
    } catch (e) {
      final error = 'backgroundFetchServiceInitialize -> initialize -> $e';
      Logger().e(error);
    }
  },
  name: 'BackgroundFetchServiceInitializeProvider',
);

@pragma('vm:entry-point')
Future<void> backgroundFetchHeadlessTask(HeadlessTask task) async {
  final taskId = task.taskId;
  final isTimeout = task.timeout;

  /// Task is timed out, finish it immediately
  if (isTimeout) {
    Logger().e('Headless task timed-out: $taskId');
    BackgroundFetch.finish(taskId);
    return;
  }

  ///
  /// Task logic
  ///
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    /// Initialize services
    final logger = LoggerService();
    final hive = HiveService(logger);
    await hive.init();
    final dioService = DioService(logger);
    final api = APIService(
      logger: logger,
      dio: dioService.dio,
    );
    final homeWidget = HomeWidgetService(
      logger: logger,
      hive: hive,
    );

    /// Get location to fetch
    final weatherIndex = hive.getActiveLocationIndexFromBox();
    final weatherList = hive.getLocationsFromBox();
    final location = weatherList.isNotEmpty ? weatherList[weatherIndex] : null;

    /// Location exists, fetch data
    if (location != null) {
      final response = await api.getCurrentWeather(
        query: '${location.lat},${location.lon}',
      );

      /// Data fetch was successful, update [HomeWidget]
      if (response.response != null && response.error == null) {
        /// Get currently active location in [WeatherScreen]
        final activeLocationSameAsResponse = (location.lat == response.response!.location.lat) && (location.lon == response.response!.location.lon);

        /// Update [HomeWidget] if `activeLocation` is being fetched
        if (activeLocationSameAsResponse) {
          /// Refresh [HomeWidget]

          await homeWidget.refreshHomeWidget(
            response: response.response!,
          );
        }
      }

      /// Data fetch wasn't successfull, throw error
      else {
        const error = "backgroundFetchHeadlessTask -> data fetch wasn't successful";
        logger.e(error);
      }
    }

    /// Location doesn't exist, throw error
    else {
      const error = "backgroundFetchHeadlessTask -> location doesn't exist";
      logger.e(error);
    }
  }

  /// Some generic error happened, throw error
  catch (e) {
    final error = 'backgroundFetchHeadlessTask -> $e';
    Logger().e(error);
  }

  /// Finish task
  BackgroundFetch.finish(taskId);
}
