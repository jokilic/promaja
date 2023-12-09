import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

import 'api_service.dart';
import 'dio_service.dart';
import 'hive_service.dart';
import 'home_widget_service.dart';
import 'logger_service.dart';

///
/// Initializes `WorkManager`
/// Used for scheduling tasks
///

final workManagerServiceInitializeProvider = FutureProvider<void>(
  (ref) async {
    /// Initialization of [WorkManager]
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );
    } catch (e) {
      final error = 'workManagerServiceInitialize -> initialize -> $e';
      Logger().e(error);
      return Future.value(false);
    }

    /// Register Android task
    if (Platform.isAndroid) {
      try {
        await Workmanager().registerPeriodicTask(
          'com.josipkilic.promaja.task',
          'com.josipkilic.promaja.task',
        );
        await Workmanager().registerPeriodicTask(
          'com.josipkilic.promaja.periodicTask',
          'com.josipkilic.promaja.periodicTask',
        );
      } catch (e) {
        final error = 'workManagerServiceInitialize -> register Android task -> $e';
        Logger().e(error);
        return Future.value(false);
      }
    }

    /// Register iOS task
    if (Platform.isIOS) {
      try {
        await Workmanager().registerOneOffTask(
          'com.josipkilic.promaja.task',
          'com.josipkilic.promaja.task',
        );
        await Workmanager().registerOneOffTask(
          'com.josipkilic.promaja.periodicTask',
          'com.josipkilic.promaja.periodicTask',
        );
      } catch (e) {
        final error = 'workManagerServiceInitialize -> register iOS task -> $e';
        Logger().e(error);
        return Future.value(false);
      }
    }
  },
  name: 'WorkManagerServiceInitializeProvider',
);

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {
  Workmanager().executeTask(
    (_, __) async {
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

            return Future.value(true);
          }

          /// Data fetch wasn't successfull, throw error
          else {
            const error = "callbackDispatcher -> data fetch wasn't successful";
            logger.e(error);
            return Future.value(false);
          }
        }

        /// Location doesn't exist, throw error
        else {
          const error = "callbackDispatcher -> location doesn't exist";
          logger.e(error);
          return Future.value(false);
        }
      }

      /// Some generic error happened, throw error
      catch (e) {
        final error = 'callbackDispatcher -> $e';
        Logger().e(error);
        return Future.value(false);
      }
    },
  );
}
