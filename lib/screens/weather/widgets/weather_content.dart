import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/current_weather/response_current_weather.dart';

class WeatherContent extends ConsumerWidget {
  final ResponseCurrentWeather weather;

  const WeatherContent({
    required this.weather,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Text(weather.name),
        ],
      );
}
