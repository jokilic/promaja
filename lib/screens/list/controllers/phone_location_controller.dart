import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../models/location/location.dart';
import '../../../services/api_service.dart';
import '../../../services/hive_service.dart';
import '../../../services/location_service.dart';

class PhoneLocationController
    extends
        ValueNotifier<
          ({
            Position? position,
            String? error,
            bool loading,
          })
        > {
  final HiveService hive;
  final APIService api;
  final LocationService location;

  PhoneLocationController({
    required this.hive,
    required this.api,
    required this.location,
  }) : super((
         position: null,
         error: null,
         loading: false,
       ));

  ///
  /// METHODS
  ///

  /// Gets phone position
  Future<void> enablePhoneLocation() async {
    /// Loading state
    value = (
      position: null,
      error: null,
      loading: true,
    );

    // TODO: Here we get new position and then also use `getCachedCurrentWeatherWithProperLocation()` which does similar. This looks like a bug / redundancy, how should we mitigate this?

    /// Get position
    final position = await location.getPosition();

    /// Position is properly calculated
    if (position.position != null) {
      /// Generate a [Location] model
      final location = Location(
        name: 'Current location',
        country: '',
        region: '',
        lat: position.position!.latitude,
        lon: position.position!.longitude,
        isPhoneLocation: true,
      );

      /// Fetch weather data
      final response = await api.getCachedCurrentWeatherWithProperLocation(
        passedLocation: location,
      );

      /// Response successfully fetched
      if (response.response != null && response.error == null) {
        final phoneLocation =
            response.response?.location.copyWith(
              isPhoneLocation: true,
            ) ??
            location;

        /// Replace phone location if it's active
        final hasReplacedPhoneLocation = await replaceActivePhoneLocation(
          location: phoneLocation,
        );

        /// Add phone location if it's not active
        if (!hasReplacedPhoneLocation) {
          /// Get currently stored `locations`
          final locations = hive.getLocationsFromBox();

          /// Add location to [Hive]
          await hive.writeAllLocationsToHive(
            locations: [
              phoneLocation,
              ...locations,
            ],
          );
        }

        value = (
          position: position.position,
          error: null,
          loading: false,
        );
      }
      /// Response returned an error
      else {
        value = (
          position: position.position,
          error: response.error?.error.message,
          loading: false,
        );
      }
    }
    /// Error getting position
    else {
      value = (
        position: null,
        error: position.error,
        loading: false,
      );
    }
  }

  /// Checks if phone location is active and replaces it
  Future<bool> replaceActivePhoneLocation({
    required Location location,
  }) async {
    /// Get currently stored `locations`
    final locations = hive.getLocationsFromBox();

    /// Get phone location index
    final phoneLocationIndex = locations.indexWhere(
      (location) => location.isPhoneLocation ?? false,
    );

    /// Return if phone location is not active
    if (phoneLocationIndex == -1) {
      return false;
    }

    /// Replace phone location while retaining its `index`
    await hive.replaceLocationInBox(
      index: phoneLocationIndex,
      location: location,
    );

    return true;
  }
}
