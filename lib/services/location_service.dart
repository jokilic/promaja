import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../constants/durations.dart';
import '../models/location/location.dart';
import 'hive_service.dart';

class LocationService {
  final HiveService hive;

  LocationService({
    required this.hive,
  });

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
        permission = await Geolocator.requestPermission();

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
          timeLimit: PromajaDurations.positionTimeout,
        ),
      );

      return (position: position, error: null);
    } catch (e) {
      final error = 'GetPosition -> catch -> $e';
      return (position: null, error: error);
    }
  }

  /// Refreshes the stored phone location and returns the location to use for notifications & widgets
  Future<Location> refreshPhoneLocation({
    required Location passedLocation,
  }) async {
    final refreshedPhoneLocation = await refreshPhoneLocationWithPosition(
      passedLocation: passedLocation,
    );

    return refreshedPhoneLocation.location;
  }

  /// Refreshes the stored phone location and also returns the GPS result
  Future<({Location location, Position? position, String? error})> refreshPhoneLocationWithPosition({
    required Location passedLocation,
  }) async {
    final position = await getPosition();

    /// Keep using the last stored position when GPS refresh fails
    if (position.position == null) {
      return (
        location: passedLocation,
        position: null,
        error: position.error,
      );
    }

    final refreshedLocation = passedLocation.copyWith(
      lat: position.position!.latitude,
      lon: position.position!.longitude,
    );

    final locations = hive.getLocationsFromBox();

    final phoneLocationIndex = locations.indexWhere(
      (location) => location.isPhoneLocation ?? false,
    );

    if (phoneLocationIndex != -1) {
      await hive.replaceLocationInBox(
        index: phoneLocationIndex,
        location: refreshedLocation,
      );
    }

    return (
      location: refreshedLocation,
      position: position.position,
      error: null,
    );
  }
}
