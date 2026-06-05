import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../constants/durations.dart';
import '../models/location/location.dart';
import 'hive_service.dart';

const phoneLocationRefreshCoordinateThreshold = 0.001;

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

  /// Returns new or saved location for the API calls
  Future<Location> getLocationForWeatherFetch({
    required Location location,
  }) async {
    if (!(location.isPhoneLocation ?? false)) {
      return location;
    }

    final position = await getPosition();

    /// Keep using the last stored coordinates when GPS refresh fails
    if (position.position == null) {
      return location;
    }

    final refreshedLocation = location.copyWith(
      lat: position.position!.latitude,
      lon: position.position!.longitude,
    );

    final shouldStoreRefreshedLocation =
        (refreshedLocation.lat - location.lat).abs() > phoneLocationRefreshCoordinateThreshold ||
        (refreshedLocation.lon - location.lon).abs() > phoneLocationRefreshCoordinateThreshold;

    if (shouldStoreRefreshedLocation) {
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
    }

    return refreshedLocation;
  }
}
