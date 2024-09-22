import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/durations.dart';
import '../../../../models/location/location.dart';
import '../../../../models/settings/units/distance_speed_unit.dart';
import '../../../../models/settings/units/precipitation_unit.dart';
import '../../../../models/settings/units/pressure_unit.dart';
import '../../../../models/settings/units/temperature_unit.dart';
import '../../../../models/weather/hour_weather.dart';
import '../../../../services/hive_service.dart';
import '../../../../util/error.dart';
import '../../weather_notifiers.dart';
import '../weather/weather_error.dart';
import '../weather/weather_loading.dart';
import '../weather_card_forecast/weather_card_forecast.dart';

class WeatherCardHistoric extends ConsumerWidget {
  final Location location;
  final String historicDate;

  const WeatherCardHistoric({
    required this.location,
    required this.historicDate,
  });

  void weatherCardHourPressed({
    required WidgetRef ref,
    required HourWeather? activeHourWeather,
    required HourWeather hourWeather,
    required int index,
  }) {
    /// User pressed already active hour
    /// Disable active hour and scroll up
    if (activeHourWeather == hourWeather) {
      ref.read(activeHourWeatherProvider.notifier).state = null;
      ref.read(showWeatherTopContainerProvider.notifier).state = false;

      ref.read(weatherCardControllerProvider(index)).animateTo(
            0,
            duration: PromajaDurations.scrollAnimation,
            curve: Curves.easeIn,
          );
    }

    /// User pressed inactive hour
    /// Enable active hour and scroll down
    else {
      ref.read(activeHourWeatherProvider.notifier).state = hourWeather;
      ref.read(showWeatherTopContainerProvider.notifier).state = true;
      if (ref.read(weatherCardHourAdditionalControllerProvider).hasClients) {
        ref.read(weatherCardHourAdditionalControllerProvider).jumpTo(0);
      }

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(weatherCardControllerProvider(index)).animateTo(
              ref.read(weatherCardControllerProvider(index)).position.maxScrollExtent,
              duration: PromajaDurations.scrollAnimation,
              curve: Curves.easeIn,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(hiveProvider.notifier).getPromajaSettingsFromBox();

    return Scaffold(
      extendBody: true,
      body: Animate(
        effects: [
          FadeEffect(
            curve: Curves.easeIn,
            duration: PromajaDurations.fadeAnimation,
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: ref.watch(getHistoricWeatherProvider((location: location, historicDate: historicDate))).when(
                    data: (data) {
                      ///
                      /// DATA SUCCESSFULLY FETCHED
                      ///
                      if (data.response != null && data.error == null) {
                        final location = data.response!.location;
                        final forecastWeather = data.response!.forecast;

                        return WeatherCardForecast(
                          index: 0,
                          location: location,
                          forecast: forecastWeather.forecastDays.first,
                          isPhoneLocation: location.isPhoneLocation ?? false,
                          showCelsius: settings.unit.temperature == TemperatureUnit.celsius,
                          showKph: settings.unit.distanceSpeed == DistanceSpeedUnit.kilometers,
                          showMm: settings.unit.precipitation == PrecipitationUnit.millimeters,
                          showhPa: settings.unit.pressure == PressureUnit.hectopascal,
                          weatherCardHourPressed: weatherCardHourPressed,
                          isHistoricWeather: true,
                        );
                      }

                      ///
                      /// ERROR WHILE FETCHING
                      ///
                      return WeatherError(
                        location: location,
                        error: getErrorDescription(errorCode: data.error?.error.code ?? 0),
                        isPhoneLocation: location.isPhoneLocation ?? false,
                        refreshPressed: () => ref.invalidate(
                          getHistoricWeatherProvider(
                            (
                              location: location,
                              historicDate: historicDate,
                            ),
                          ),
                        ),
                        isHistoricWeather: true,
                      );
                    },
                    error: (error, stackTrace) => WeatherError(
                      location: location,
                      error: '$error',
                      isPhoneLocation: location.isPhoneLocation ?? false,
                      refreshPressed: () => ref.invalidate(
                        getHistoricWeatherProvider(
                          (
                            location: location,
                            historicDate: historicDate,
                          ),
                        ),
                      ),
                      isHistoricWeather: true,
                    ),
                    loading: () => WeatherLoading(
                      location: location,
                      isWeatherSummary: false,
                    ),
                  ),
            ),
            SizedBox(
              height: MediaQuery.paddingOf(context).bottom + 24,
            ),
          ],
        ),
      ),
    );
  }
}
