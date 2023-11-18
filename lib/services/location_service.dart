import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'logger_service.dart';

final locationProvider = Provider<LocationService>(
  (ref) => LocationService(
    logger: ref.watch(loggerProvider),
  ),
  name: 'LocationService',
);

class LocationService {
  final LoggerService logger;

  LocationService({
    required this.logger,
  });

  /// Determine the current position of the device
  Future<({Position? position, String? error})> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    /// Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    /// Location services are not enabled, return error
    if (!serviceEnabled) {
      const error = 'LocationService -> Location services are not enabled';
      logger.e(error);
      return (position: null, error: error);
    }

    /// Check location permission
    permission = await Geolocator.checkPermission();

    /// Permission is denied, request it
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      /// Permission is denied, return error
      if (permission == LocationPermission.denied) {
        const error = 'LocationService -> Location permissions are denied';
        logger.e(error);
        return (position: null, error: error);
      }
    }

    /// Permission are denied forever, return error
    if (permission == LocationPermission.deniedForever) {
      const error = 'LocationService -> Location permissions are permanently denied';
      logger.e(error);
      return (position: null, error: error);
    }

    /// Permissions are granted, access position
    final position = await Geolocator.getCurrentPosition();
    return (position: position, error: null);
  }
}
