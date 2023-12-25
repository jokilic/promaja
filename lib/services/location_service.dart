import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../util/log_data.dart';
import 'hive_service.dart';
import 'logger_service.dart';

final locationProvider = Provider<LocationService>(
  (ref) => LocationService(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'LocationService',
);

class LocationService {
  final LoggerService logger;
  final HiveService hive;

  LocationService({
    required this.logger,
    required this.hive,
  });

  /// Determine the current position of the device
  Future<({Position? position, String? error})> getPosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      /// Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      /// Location services are not enabled, return error
      if (!serviceEnabled) {
        const error = 'LocationService -> getPosition -> Location services are not enabled';
        logError(
          logger: logger,
          hive: hive,
          text: error,
        );
        return (position: null, error: error);
      }

      /// Check location permission
      permission = await Geolocator.checkPermission();

      /// Permission is denied, request it
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        /// Permission is denied, return error
        if (permission == LocationPermission.denied) {
          const error = 'LocationService -> getPosition -> Location permissions are denied';
          logError(
            logger: logger,
            hive: hive,
            text: error,
          );
          return (position: null, error: error);
        }
      }

      /// Permission are denied forever, return error
      if (permission == LocationPermission.deniedForever) {
        const error = 'LocationService -> getPosition -> Location permissions are permanently denied';
        logError(
          logger: logger,
          hive: hive,
          text: error,
        );
        return (position: null, error: error);
      }

      /// Permissions are granted, access position
      final position = await Geolocator.getCurrentPosition();
      logInfo(
        logger: logger,
        hive: hive,
        text: 'LocationService -> getPosition -> Location fetched',
      );
      return (position: position, error: null);
    } catch (e) {
      final error = 'LocationService -> getPosition -> $e';
      logError(
        logger: logger,
        hive: hive,
        text: error,
      );
      return (position: null, error: error);
    }
  }
}
