import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'hive_service.dart';
import 'logger_service.dart';

final locationProvider = Provider<LocationService>(
  (ref) => LocationService(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'LocationProvider',
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
        const error = 'GetPosition -> Location services not enabled';
        unawaited(Sentry.captureException(error));
        return (position: null, error: error);
      }

      /// Check location permission
      permission = await Geolocator.checkPermission();

      /// Permission is denied, request it
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        /// Permission is denied, return error
        if (permission == LocationPermission.denied) {
          const error = 'GetPosition -> Location permissions denied';
          unawaited(Sentry.captureException(error));
          return (position: null, error: error);
        }
      }

      /// Permission are denied forever, return error
      if (permission == LocationPermission.deniedForever) {
        const error = 'GetPosition -> Location permissions permanently denied';
        unawaited(Sentry.captureException(error));
        return (position: null, error: error);
      }

      /// Permissions are granted, access position
      final position = await Geolocator.getCurrentPosition();

      return (position: position, error: null);
    } catch (e) {
      final error = 'GetPosition -> catch -> $e';
      unawaited(Sentry.captureException(error));
      return (position: null, error: error);
    }
  }
}
