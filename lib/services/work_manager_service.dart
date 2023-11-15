import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

import 'api_service.dart';
import 'dio_service.dart';
import 'hive_service.dart';
import 'home_widget_service.dart';
import 'logger_service.dart';

///
/// Service which initializes `WorkManager`
/// Used for scheduling tasks
///

final workManagerProvider = Provider<WorkManagerService>(
  (_) => throw UnimplementedError(),
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
}

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async => Workmanager().executeTask(
      (task, inputData) async {
        try {
          /// Initialize services
          final logger = LoggerService();
          final dio = DioService(logger);
          final api = APIService(
            logger: logger,
            dio: dio.dio,
          );
          final hive = HiveService(logger);
          await hive.init();
          final homeWidget = HomeWidgetService(
            logger: logger,
            hive: hive,
          );

          /// Get location to fetch
          final location = hive.getLocationsFromBox().firstOrNull;

          /// Location exists
          if (location != null) {
            /// Fetch weather data for location
            final response = await api.getForecastWeather(
              query: '${location.lat},${location.lon}',
              days: 3,
            );

            /// Response is successful
            if (response.response != null && response.error == null) {
              /// Update [HomeWidget]
              await homeWidget.refreshHomeWidget(
                response: response.response!,
                homeWidget: homeWidget,
              );

              return Future.value(true);
            }

            /// There was an error fetching weather
            else {
              final error = 'callbackDispatcher -> error fetching weather -> ${response.error}';
              Logger().e(error);
              return Future.error(error);
            }
          }

          /// Location doesn't exist, don't do anything
          else {
            const info = "callbackDispatcher -> location doesn't exist";
            Logger().i(info);
            return Future.value(false);
          }
        } catch (e) {
          final error = 'callbackDispatcher - $e';
          Logger().e(error);
          return Future.error(error);
        }
      },
    );