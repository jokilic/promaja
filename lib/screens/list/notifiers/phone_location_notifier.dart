import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../services/location_service.dart';

final phoneLocationProvider = StateNotifierProvider<PhoneLocationNotifier, ({Position? position, String? error, bool loading})>(
  (ref) => PhoneLocationNotifier(ref: ref),
  name: 'PhoneLocationProvider',
);

final getPhonePositionProvider = FutureProvider<({Position? position, String? error})>(
  (ref) async => ref.read(locationProvider).getPosition(),
  name: 'GetPhonePositionProvider',
);

class PhoneLocationNotifier extends StateNotifier<({Position? position, String? error, bool loading})> {
  final Ref ref;

  PhoneLocationNotifier({
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
  }
}
