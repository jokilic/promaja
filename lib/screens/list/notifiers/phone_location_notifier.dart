import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../models/location/location.dart';
import '../../../services/hive_service.dart';
import '../../../services/location_service.dart';

final phoneLocationProvider = StateNotifierProvider<PhoneLocationNotifier, ({Position? position, String? error, bool loading})>(
  (ref) => PhoneLocationNotifier(
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
  final HiveService hiveService;
  final Ref ref;

  PhoneLocationNotifier({
    required this.hiveService,
    required this.ref,
  }) : super((
          position: null,
          error: null,
          loading: false,
        ));

  ///
  /// METHODS
  ///

  /// Gets phone position
  Future<void> getPosition() async {
    /// Loading state
    state = (
      position: null,
      error: null,
      loading: true,
    );

    /// Get position
    final position = await ref.read(getPhonePositionProvider.future);

    state = (
      position: position.position,
      error: position.error,
      loading: false,
    );

    /// Position is properly calculated
    if (position.position != null) {
      /// Add location to [Hive]
      await hiveService.writeAllLocationsToHive(
        locations: [
          Location(
            name: 'Current location',
            country: '',
            region: '',
            lat: position.position!.latitude,
            lon: position.position!.longitude,
            isPhoneLocation: true,
          ),
          ...hiveService.state,
        ],
      );
    }

    state = (
      position: position.position,
      error: position.error,
      loading: false,
    );
  }
}
