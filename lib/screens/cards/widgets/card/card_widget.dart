import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/location/location.dart';
import '../../../../services/home_widget_service.dart';
import '../../cards_notifiers.dart';
import 'card_error.dart';
import 'card_loading.dart';
import 'card_success.dart';

class CardWidget extends ConsumerWidget {
  final Location originalLocation;
  final bool useOpacity;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const CardWidget({
    required this.originalLocation,
    required this.useOpacity,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
        child: ref.watch(getCurrentWeatherProvider(originalLocation)).when(
              data: (data) {
                ///
                /// DATA SUCCESSFULLY FETCHED
                ///
                if (data.response != null && data.error == null) {
                  /// Update [HomeWidget]
                  unawaited(ref.read(updateHomeWidgetProvider(data.response!).future));

                  final location = data.response!.location;
                  final currentWeather = data.response!.current;

                  return CardSuccess(
                    location: location,
                    currentWeather: currentWeather,
                    useOpacity: useOpacity,
                    isPhoneLocation: originalLocation.isPhoneLocation,
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
                  error: data.error?.error.message ?? data.genericError ?? 'weirdErrorHappened'.tr(),
                  useOpacity: useOpacity,
                  isPhoneLocation: originalLocation.isPhoneLocation,
                );
              },

              ///
              /// ERROR STATE
              ///
              error: (error, _) => CardError(
                location: originalLocation,
                error: '$error',
                useOpacity: useOpacity,
                isPhoneLocation: originalLocation.isPhoneLocation,
              ),

              ///
              /// LOADING STATE
              ///
              loading: () => CardLoading(
                location: originalLocation,
                useOpacity: useOpacity,
              ),
            ),
      );
}
