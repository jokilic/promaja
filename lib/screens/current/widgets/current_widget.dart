import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:watch_it/watch_it.dart';

import '../../../constants/typedefs.dart';
import '../../../models/location/location.dart';
import '../../../services/api_service.dart';
import '../../../util/error.dart';
import 'current_error.dart';
import 'current_loading.dart';
import 'current_success.dart';

class CurrentWidget extends WatchingWidget {
  final Location originalLocation;
  final bool showCelsius;
  final bool showKph;
  final bool showMm;
  final bool showhPa;

  const CurrentWidget({
    required this.originalLocation,
    required this.showCelsius,
    required this.showKph,
    required this.showMm,
    required this.showhPa,
  });

  @override
  Widget build(BuildContext context) {
    final futureSnapshot = watchFuture<APIService, CurrentWeatherResult>(
      (api) => api.getCachedCurrentWeather(
        query: '${originalLocation.lat},${originalLocation.lon}',
      ),
      initialValue: (
        response: null,
        error: null,
        genericError: null,
      ),
    );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(40),
      ),
      child: Builder(
        builder: (context) {
          ///
          /// LOADING
          ///
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return CurrentLoading(
              location: originalLocation,
            );
          }

          ///
          /// ERROR
          ///
          if (futureSnapshot.hasError) {
            final error = futureSnapshot.error;

            return CurrentError(
              locationName: originalLocation.name,
              error: '$error',
              isPhoneLocation: originalLocation.isPhoneLocation ?? false,
              // TODO: Refresh logic
              // refreshPressed: () => ref.invalidate(
              //   getCurrentWeatherProvider(originalLocation),
              // ),
            );
          }

          ///
          /// SUCCESS
          ///
          final data = futureSnapshot.data;

          ///
          /// DATA SUCCESSFULLY FETCHED
          ///
          if (data?.response != null && data?.error == null) {
            /// Remove splash screen
            FlutterNativeSplash.remove();

            final currentWeather = data!.response!.current;
            final location = data.response!.location;

            return CurrentSuccess(
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
          return CurrentError(
            locationName: originalLocation.name,
            error: getErrorDescription(
              errorCode: data?.error?.error.code ?? 0,
            ),
            isPhoneLocation: originalLocation.isPhoneLocation ?? false,
            // TODO: Refresh logic
            // refreshPressed: () => ref.invalidate(
            //   getCurrentWeatherProvider(originalLocation),
            // ),
          );
        },
      ),
    );
  }
}
