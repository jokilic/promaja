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

  /// Refreshes phone location if it's active
  Future<void> refreshPhoneLocation() async {
    /// Get currently stored `locations`
    final locations = hive.getLocationsFromBox();

    /// Check if phone location is active
    final hasPhoneLocation = locations.any(
      (location) => location.isPhoneLocation ?? false,
    );

    /// Enable phone location with new position
    if (hasPhoneLocation) {
      await enablePhoneLocation();
    }
  }

  /// Gets phone position
  Future<void> enablePhoneLocation() async {
    /// Loading state
    value = (
      position: null,
      error: null,
      loading: true,
    );

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
      final response = await api.getCurrentWeather(
        query: '${location.lat},${location.lon}',
      );

      /// Response successfully fetched
      if (response.response != null && response.error == null) {
        /// Remove phone location if it's active
        await removeActivePhoneLocation();

        /// Get currently stored `locations`
        final locations = hive.getLocationsFromBox();

        /// Add location to [Hive]
        await hive.writeAllLocationsToHive(
          locations: [
            response.response?.location.copyWith(isPhoneLocation: true) ?? location,
            ...locations,
          ],
        );

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

  /// Checks if phone location is active and removes it
  Future<void> removeActivePhoneLocation() async {
    /// Get currently stored `locations`
    final locations = hive.getLocationsFromBox();

    /// Check if phone location is active
    final hasPhoneLocation = locations.any(
      (location) => location.isPhoneLocation ?? false,
    );

    /// Remove phone location
    if (hasPhoneLocation) {
      final phoneLocationIndex = locations.indexWhere(
        (location) => location.isPhoneLocation ?? false,
      );

      await hive.deleteLocationFromBox(
        index: phoneLocationIndex,
      );
    }
  }
}
