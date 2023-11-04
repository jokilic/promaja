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
  final Location? location;

  const WeatherScreen({
    required this.location,
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
          child: location != null
              ? ref.watch(getForecastWeatherProvider((location: location!, days: 3))).when(
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
                        );
                      }

                      ///
                      /// ERROR WHILE FETCHING
                      ///
                      return WeatherError(
                        location: location!,
                        error: data.error ?? 'Some weird error happened',
                      );
                    },
                    error: (error, stackTrace) => WeatherError(
                      location: location!,
                      error: '$error',
                    ),
                    loading: () => WeatherLoading(
                      location: location!,
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
                  error: 'No more locations',
                ),
        ),
      );
}
