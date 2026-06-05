import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../constants/durations.dart';

class LocationService {
  ///
  /// METHODS
  ///

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
        return (position: null, error: error);
      }

      /// Check location permission
      permission = await Geolocator.checkPermission();

      /// Permission is denied, request it
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission().timeout(
          PromajaDurations.permissionTimeout,
        );

        /// Permission is denied, return error
        if (permission == LocationPermission.denied) {
          const error = 'GetPosition -> Location permissions denied';
          return (position: null, error: error);
        }
      }

      /// Permission are denied forever, return error
      if (permission == LocationPermission.deniedForever) {
        const error = 'GetPosition -> Location permissions permanently denied';
        return (position: null, error: error);
      }

      /// Permissions are granted, access position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          timeLimit: PromajaDurations.permissionTimeout,
        ),
      );

      return (position: position, error: null);
    } catch (e) {
      final error = 'GetPosition -> catch -> $e';
      return (position: null, error: error);
    }
  }
}
