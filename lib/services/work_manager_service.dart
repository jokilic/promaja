import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

import '../screens/cards/cards_notifiers.dart';
import '../screens/weather/weather_notifiers.dart';
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
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
          initialDelay: const Duration(hours: 1),
          frequency: const Duration(hours: 1),
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
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
          initialDelay: const Duration(hours: 1),
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
Future<void> callbackDispatcher() async => Workmanager().executeTask(
      (_, __) async {
        try {
          WidgetsFlutterBinding.ensureInitialized();
          DartPluginRegistrant.ensureInitialized();
          await EasyLocalization.ensureInitialized();

          /// Initialize services
          final container = ProviderContainer();
          final logger = container.read(loggerProvider);
          final hive = container.read(hiveProvider.notifier);
          await hive.init();

          /// Get location to fetch
          final location = container.read(activeWeatherProvider);

          /// Location exists, fetch data
          if (location != null) {
            final response = await container.read(getCurrentWeatherProvider(location).future);

            /// Data fetch was successful, update [HomeWidget]
            if (response.response != null && response.error == null) {
              await container.read(updateHomeWidgetProvider(response.response!).future);
              return Future.value(true);
            }

            /// Data fetch wasn't successfull, throw error
            else {
              const error = "backgroundUpdate -> data fetch wasn't successful";
              logger.e(error);
              return Future.value(false);
            }
          }

          /// Location doesn't exist, throw error
          else {
            const error = "backgroundUpdate -> location doesn't exist";
            logger.e(error);
            return Future.value(false);
          }
        }

        /// Some generic error happened, throw error
        catch (e) {
          final error = 'backgroundUpdate -> $e';
          Logger().e(error);
          return Future.value(false);
        }
      },
    );
