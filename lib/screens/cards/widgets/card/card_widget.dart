import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/location/location.dart';
import '../../../../util/error.dart';
import '../../cards_notifiers.dart';
import 'card_error.dart';
import 'card_loading.dart';
import 'card_success.dart';

class CardWidget extends ConsumerWidget {
  final Location originalLocation;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const CardWidget({
    required this.originalLocation,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: ref.watch(getCurrentWeatherProvider(originalLocation)).when(
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
                    isPhoneLocation: originalLocation.isPhoneLocation ?? false,
                    showCelsius: showCelsius,
                    showKph: showKph,
                    showMm: showMm,
                    showhPa: showhPa,
                  );
                }

                ///
                /// ERROR WHILE FETCHING
                ///
                return CardError(
                  location: originalLocation,
                  error: getErrorDescription(errorCode: data.error?.error.code ?? 0),
                  isPhoneLocation: originalLocation.isPhoneLocation ?? false,
                  refreshPressed: () => ref.invalidate(
                    getCurrentWeatherProvider(originalLocation),
                  ),
                );
              },

              ///
              /// ERROR STATE
              ///
              error: (error, _) => CardError(
                location: originalLocation,
                error: '$error',
                isPhoneLocation: originalLocation.isPhoneLocation ?? false,
                refreshPressed: () => ref.invalidate(
                  getCurrentWeatherProvider(originalLocation),
                ),
              ),

              ///
              /// LOADING STATE
              ///
              loading: () => CardLoading(
                location: originalLocation,
              ),
            ),
      );
}
