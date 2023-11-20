import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
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

final backgroundServiceInitializeProvider = FutureProvider<void>(
  (ref) async {
    /// Initialization of [FlutterBackgroundService]
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundUpdate,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: backgroundUpdate,
        onBackground: backgroundUpdate,
      ),
    );

    final isRunning = await service.isRunning();
    ref.read(loggerProvider).f('SERVICE IS RUNNING: $isRunning');

    await service.startService();

    final isRunningNow = await service.isRunning();
    ref.read(loggerProvider).f('SERVICE IS RUNNING NOW: $isRunningNow');
  },
  name: 'BackgroundFetchInitializeProvider',
);

@pragma('vm:entry-point')
Future<bool> backgroundUpdate(ServiceInstance service) async {
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
        return Future.error(error);
      }
    }

    /// Location doesn't exist, throw error
    else {
      const error = "backgroundUpdate -> location doesn't exist";
      logger.e(error);
      return Future.error(error);
    }
  }

  /// Some generic error happened, throw error
  catch (e) {
    final error = 'backgroundUpdate -> $e';
    Logger().e(error);
    return Future.error(error);
  }
}
