import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

import '../screens/cards/cards_notifiers.dart';
import '../screens/weather/weather_notifiers.dart';
import 'hive_service.dart';
import 'home_widget_service.dart';
import 'logger_service.dart';

///
/// Service which initializes `WorkManager`
/// Used for scheduling tasks
///

final workManagerProvider = Provider<WorkManagerService>(
  (ref) => WorkManagerService(
    ref.watch(loggerProvider),
  ),
  name: 'WorkManagerProvider',
);

class WorkManagerService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  WorkManagerService(this.logger)

  ///
  /// INIT
  ///

  {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  ///
  /// METHODS
  ///

  /// Registers [WorkManager] task
  void registerTask() {
    if (Platform.isIOS) {
      Workmanager().registerOneOffTask(
        'com.josipkilic.promaja.one_off_task',
        'com.josipkilic.promaja.one_off_task',
        tag: 'promaja_task',
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    }

    if (Platform.isAndroid) {
      Workmanager().registerPeriodicTask(
        'com.josipkilic.promaja.periodic_task',
        'com.josipkilic.promaja.periodic_task',
        tag: 'promaja_task',
        frequency: const Duration(hours: 1),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    }
  }
}

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async => Workmanager().executeTask(
      (task, inputData) async {
        try {
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
              const error = "callbackDispatcher -> data fetch wasn't successful";
              logger.e(error);
              return Future.error(error);
            }
          }

          /// Location doesn't exist, throw error
          else {
            const error = "callbackDispatcher -> location doesn't exist";
            logger.e(error);
            return Future.error(error);
          }
        }

        /// Some generic error happened, throw error
        catch (e) {
          final error = 'callbackDispatcher -> $e';
          Logger().e(error);
          return Future.error(error);
        }
      },
    );
