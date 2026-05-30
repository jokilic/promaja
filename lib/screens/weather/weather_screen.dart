import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../models/error/response_error.dart';
import '../../models/location/location.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/precipitation_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../models/weather/response_forecast_weather.dart';
import '../../services/api_service.dart';
import '../../services/hive_service.dart';
import '../../util/dependencies.dart';
import '../../util/error.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'widgets/weather/weather_error.dart';
import 'widgets/weather/weather_loading.dart';
import 'widgets/weather/weather_success.dart';

class WeatherScreen extends WatchingWidget {
  final Location? originalLocation;

  const WeatherScreen({
    required this.originalLocation,
  });

  @override
  Widget build(BuildContext context) {
    final futureSnapshot = watchFuture<APIService, ({ResponseForecastWeather? response, ResponseError? error, String? genericError})>(
      (api) => api.getForecastWeather(
        query: '${originalLocation?.lat},${originalLocation?.lon}',
        days: 7,
      ),
      initialValue: (
        response: null,
        error: null,
        genericError: null,
      ),
    );

    final hive = getIt.get<HiveService>();
    final settings = hive.getPromajaSettingsFromBox();

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: PromajaNavigationBar(),
      body: Animate(
        effects: [
          FadeEffect(
            curve: Curves.easeIn,
            duration: PromajaDurations.fadeAnimation,
          ),
        ],
        child: Builder(
          builder: (context) {
            ///
            /// LOCATION EXISTS
            ///
            if (originalLocation != null) {
              ///
              /// LOADING
              ///
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return WeatherLoading(
                  location: originalLocation!,
                  isWeatherSummary: settings.appearance.weatherSummaryFirst,
                );
              }

              ///
              /// ERROR
              ///
              if (futureSnapshot.hasError) {
                final error = futureSnapshot.error;

                return WeatherError(
                  location: originalLocation!,
                  error: '$error',
                  isPhoneLocation: originalLocation?.isPhoneLocation ?? false,
                  // TODO: Refresh logic
                  // refreshPressed: () => ref.invalidate(
                  //   getForecastWeatherProvider(
                  //     (location: originalLocation!, days: 7),
                  //   ),
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

                final forecastWeather = data!.response!.forecast;
                final location = data.response!.location;

                return WeatherSuccess(
                  location: location,
                  forecastWeather: forecastWeather,
                  isPhoneLocation: originalLocation?.isPhoneLocation ?? false,
                  showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
                  showKph: settings.unit.distanceSpeed == DistanceSpeedUnit.kilometers,
                  showMm: settings.unit.precipitation == PrecipitationUnit.millimeters,
                  showhPa: settings.unit.pressure == PressureUnit.hectopascal,
                );
              }

              ///
              /// ERROR WHILE FETCHING
              ///
              return WeatherError(
                location: originalLocation!,
                error: getErrorDescription(
                  errorCode: data?.error?.error.code ?? 0,
                ),
                isPhoneLocation: originalLocation?.isPhoneLocation ?? false,
                // TODO: Refresh logic
                // refreshPressed: () => ref.invalidate(
                //   getForecastWeatherProvider(
                //     (location: originalLocation!, days: 7),
                //   ),
                // ),
              );
            }

            ///
            /// LOCATION DOESN'T EXIST
            ///
            return WeatherError(
              location: Location(
                country: '---',
                lat: 0,
                lon: 0,
                name: '---',
                region: '---',
              ),
              error: 'noMoreLocations'.tr(),
              isPhoneLocation: originalLocation?.isPhoneLocation ?? false,
            );
          },
        ),
      ),
    );
  }
}
