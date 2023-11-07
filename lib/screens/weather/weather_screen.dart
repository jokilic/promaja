import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/durations.dart';
import '../../models/location/location.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'weather_notifiers.dart';
import 'widgets/weather/weather_error.dart';
import 'widgets/weather/weather_loading.dart';
import 'widgets/weather/weather_success.dart';

class WeatherScreen extends ConsumerWidget {
  final Location? originalLocation;

  const WeatherScreen({
    required this.originalLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        bottomNavigationBar: PromajaNavigationBar(),
        body: Animate(
          key: ValueKey(ref.read(navigationBarIndexProvider)),
          effects: [
            FadeEffect(
              curve: Curves.easeIn,
              duration: PromajaDurations.fadeAnimation,
            ),
          ],
          child: originalLocation != null
              ? ref.watch(getForecastWeatherProvider((location: originalLocation!, days: 7))).when(
                    data: (data) {
                      ///
                      /// DATA SUCCESSFULLY FETCHED
                      ///
                      if (data.response != null && data.error == null) {
                        final location = data.response!.location;
                        final currentWeather = data.response!.current;
                        final forecastWeather = data.response!.forecast;

                        return WeatherSuccess(
                          location: location,
                          currentWeather: currentWeather,
                          forecastWeather: forecastWeather,
                          isPhoneLocation: originalLocation?.isPhoneLocation ?? false,
                        );
                      }

                      ///
                      /// ERROR WHILE FETCHING
                      ///
                      return WeatherError(
                        location: originalLocation!,
                        error: data.error ?? 'weirdErrorHappened'.tr(),
                        isPhoneLocation: originalLocation?.isPhoneLocation ?? false,
                      );
                    },
                    error: (error, stackTrace) => WeatherError(
                      location: originalLocation!,
                      error: '$error',
                      isPhoneLocation: originalLocation?.isPhoneLocation ?? false,
                    ),
                    loading: () => WeatherLoading(
                      location: originalLocation!,
                    ),
                  )
              : WeatherError(
                  location: Location(
                    country: '---',
                    lat: 0,
                    lon: 0,
                    name: '---',
                    region: '---',
                  ),
                  error: 'noMoreLocations'.tr(),
                  isPhoneLocation: originalLocation?.isPhoneLocation ?? false,
                ),
        ),
      );
}
