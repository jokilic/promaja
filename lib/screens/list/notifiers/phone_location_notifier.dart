import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../models/location/location.dart';
import '../../../services/hive_service.dart';
import '../../../services/location_service.dart';
import '../../../services/logger_service.dart';
import '../../cards/cards_notifiers.dart';

final phoneLocationProvider = StateNotifierProvider<PhoneLocationNotifier, ({Position? position, String? error, bool loading})>(
  (ref) => PhoneLocationNotifier(
    logger: ref.watch(loggerProvider),
    hiveService: ref.watch(hiveProvider.notifier),
    ref: ref,
  ),
  name: 'PhoneLocationProvider',
);

final getPhonePositionProvider = FutureProvider<({Position? position, String? error})>(
  (ref) async => ref.read(locationProvider).getPosition(),
  name: 'GetPhonePositionProvider',
);

class PhoneLocationNotifier extends StateNotifier<({Position? position, String? error, bool loading})> {
  final LoggerService logger;
  final HiveService hiveService;
  final Ref ref;

  PhoneLocationNotifier({
    required this.logger,
    required this.hiveService,
    required this.ref,
  }) : super((
          position: null,
          error: null,
          loading: false,
        ));

  ///
  /// INIT
  ///

  /// Refreshes phone location if it's active
  Future<void> refreshPhoneLocation() async {
    /// Check if phone location is active
    final hasPhoneLocation = hiveService.state.any(
      (location) => location.isPhoneLocation ?? false,
    );

    /// Enable phone location with new position
    if (hasPhoneLocation) {
      await enablePhoneLocation();
    }
  }

  ///
  /// METHODS
  ///

  /// Gets phone position
  Future<void> enablePhoneLocation() async {
    /// Loading state
    state = (
      position: null,
      error: null,
      loading: true,
    );

    /// Get position
    final position = await ref.read(getPhonePositionProvider.future);

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
      final response = await ref.read(getCurrentWeatherProvider(location).future);

      /// Response successfully fetched
      if (response.response != null && response.error == null) {
        /// Remove phone location if it's active
        await removeActivePhoneLocation();

        /// Add location to [Hive]
        await hiveService.writeAllLocationsToHive(
          locations: [
            response.response?.location.copyWith(isPhoneLocation: true) ?? location,
            ...hiveService.state,
          ],
        );

        state = (
          position: position.position,
          error: null,
          loading: false,
        );
      }

      /// Response returned an error
      else {
        state = (
          position: position.position,
          error: response.error?.error.message,
          loading: false,
        );
      }
    }

    /// Error getting position
    else {
      state = (
        position: null,
        error: position.error,
        loading: false,
      );
    }
  }

  /// Checks if phone location is active and removes it
  Future<void> removeActivePhoneLocation() async {
    final hasPhoneLocation = hiveService.state.any(
      (location) => location.isPhoneLocation ?? false,
    );

    if (hasPhoneLocation) {
      final phoneLocationIndex = hiveService.state.indexWhere(
        (location) => location.isPhoneLocation ?? false,
      );

      await hiveService.deleteLocationFromBox(
        index: phoneLocationIndex,
      );
    }
  }
}
