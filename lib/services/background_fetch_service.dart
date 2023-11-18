import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../screens/cards/cards_notifiers.dart';
import '../screens/weather/weather_notifiers.dart';
import 'hive_service.dart';
import 'home_widget_service.dart';
import 'logger_service.dart';

///
/// Service which initializes `BackgroundFetch`
/// Used for scheduling tasks
///

final backgroundFetchProvider = Provider<BackgroundFetchService>(
  (ref) => BackgroundFetchService(
    ref.watch(loggerProvider),
  ),
  name: 'BackgroundFetchProvider',
);

class BackgroundFetchService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  BackgroundFetchService(this.logger);

  ///
  /// METHODS
  ///

  /// Registers [WorkManager] task
  void registerTask() {}
}

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {
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
}
