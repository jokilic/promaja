import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/location/location.dart';
import '../../cards_notifiers.dart';
import 'card_error.dart';
import 'card_loading.dart';
import 'card_success.dart';

class CardWidget extends ConsumerWidget {
  final Location location;
  final bool useOpacity;

  const CardWidget({
    required this.location,
    required this.useOpacity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
        child: ref.watch(getCurrentWeatherProvider(location)).when(
              data: (data) {
                ///
                /// DATA SUCCESSFULLY FETCHED
                ///
                if (data.response != null && data.error == null) {
                  final location = data.response!.location;
                  final currentWeather = data.response!.current;

                  return CardSuccess(
                    location: location,
                    currentWeather: currentWeather,
                    useOpacity: useOpacity,
                  );
                }

                ///
                /// ERROR WHILE FETCHING
                ///
                return CardError(
                  location: location,
                  error: data.error ?? 'Some weird error happened',
                  useOpacity: useOpacity,
                );
              },

              ///
              /// ERROR STATE
              ///
              error: (error, _) => CardError(
                location: location,
                error: '$error',
                useOpacity: useOpacity,
              ),

              ///
              /// LOADING STATE
              ///
              loading: () => CardLoading(
                location: location,
                useOpacity: useOpacity,
              ),
            ),
      );
}
