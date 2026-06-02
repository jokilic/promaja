import 'dart:developer';

import '../models/location/location.dart';
import 'hive_service.dart';
import 'location_service.dart';

class PhoneLocationService {
  final HiveService hive;
  final LocationService location;

  PhoneLocationService({
    required this.hive,
    required this.location,
  }) {
    refreshPhoneLocation();
  }

  ///
  /// METHODS
  ///

  /// Refreshes stored phone location if one is active
  Future<Location?> refreshPhoneLocation({
    Location? passedLocation,
  }) async {
    try {
      final storedPhoneLocation = getStoredPhoneLocation();
      final phoneLocation = (passedLocation?.isPhoneLocation ?? false) ? passedLocation : storedPhoneLocation;

      if (phoneLocation == null) {
        return passedLocation;
      }

      final position = await location.getPosition();

      /// Keep using the last stored position when GPS refresh fails
      if (position.position == null) {
        return phoneLocation;
      }

      final locationWithFreshCoordinates = phoneLocation.copyWith(
        lat: position.position!.latitude,
        lon: position.position!.longitude,
        isPhoneLocation: true,
      );

      log('Location -> ${position.position!.latitude} -> ${position.position!.longitude}');

      await replaceStoredPhoneLocation(
        location: locationWithFreshCoordinates,
      );

      return locationWithFreshCoordinates;
    } catch (_) {
      return passedLocation;
    }
  }

  /// Gets currently stored phone location from [Hive]
  Location? getStoredPhoneLocation() => hive.getLocationsFromBox().where((location) => location.isPhoneLocation ?? false).firstOrNull;

  /// Replaces currently stored phone location while retaining its index
  Future<void> replaceStoredPhoneLocation({required Location location}) async {
    final locations = hive.getLocationsFromBox();
    final phoneLocationIndex = locations.indexWhere(
      (location) => location.isPhoneLocation ?? false,
    );

    if (phoneLocationIndex == -1) {
      return;
    }

    await hive.replaceLocationInBox(
      index: phoneLocationIndex,
      location: location,
    );
  }
}
