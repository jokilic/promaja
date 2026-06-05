import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../constants/typedefs.dart';
import '../../models/location/location.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/precipitation_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../services/api_service.dart';
import '../../services/hive_service.dart';
import '../../util/dependencies.dart';
import '../../util/error.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'weather_controller.dart';
import 'widgets/weather/weather_error.dart';
import 'widgets/weather/weather_loading.dart';
import 'widgets/weather/weather_success.dart';

class WeatherScreen extends WatchingStatefulWidget {
  final Location? originalLocation;

  const WeatherScreen({
    required this.originalLocation,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<WeatherController>(
      WeatherController.new,
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<WeatherController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final futureSnapshot = watchFuture<APIService, ForecastWeatherResult>(
      (api) async {
        final originalLocation = widget.originalLocation;

        if (originalLocation == null) {
          return (
            response: null,
            error: null,
            genericError: null,
          );
        }

        return api.getCachedForecastWeather(
          passedLocation: originalLocation,
          days: 7,
        );
      },
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
            if (widget.originalLocation != null) {
              ///
              /// LOADING
              ///
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return WeatherLoading(
                  originalLocation: widget.originalLocation!,
                  isWeatherSummary: settings.appearance.weatherSummaryFirst,
                );
              }

              ///
              /// ERROR
              ///
              if (futureSnapshot.hasError) {
                final error = futureSnapshot.error;

                return WeatherError(
                  originalLocation: widget.originalLocation!,
                  error: '$error',
                  isPhoneLocation: widget.originalLocation?.isPhoneLocation ?? false,
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

                return WeatherSuccess(
                  originalLocation: widget.originalLocation!,
                  forecastWeather: forecastWeather,
                  isPhoneLocation: widget.originalLocation?.isPhoneLocation ?? false,
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
                originalLocation: widget.originalLocation!,
                error: getErrorDescription(
                  errorCode: data?.error?.error.code ?? 0,
                ),
                isPhoneLocation: widget.originalLocation?.isPhoneLocation ?? false,
              );
            }

            ///
            /// LOCATION DOESN'T EXIST
            ///
            return WeatherError(
              originalLocation: Location(
                country: '---',
                lat: 0,
                lon: 0,
                name: '---',
                region: '---',
              ),
              error: 'noMoreLocations'.tr(),
              isPhoneLocation: widget.originalLocation?.isPhoneLocation ?? false,
            );
          },
        ),
      ),
    );
  }
}
