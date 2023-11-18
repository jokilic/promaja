import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

import '../screens/cards/cards_notifiers.dart';
import '../screens/weather/weather_notifiers.dart';
import 'hive_service.dart';
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

          /// Location exists, fetch data & update [HomeWidget]
          if (location != null) {
            await container.read(getCurrentWeatherProvider(location).future);
            return Future.value(true);
          }

          /// Location doesn't exist, don't do anything
          else {
            const info = "callbackDispatcher -> location doesn't exist";
            logger.i(info);
            return Future.value(false);
          }
        } catch (e) {
          final error = 'callbackDispatcher - $e';
          Logger().e(error);
          return Future.error(error);
        }
      },
    );
