import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'weather_controller.dart';
import 'widgets/weather_content.dart';

class WeatherScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider(context));

    return Scaffold(
      body: weatherState.when(
        data: (weather) => WeatherContent(weather: weather!),
        error: (error, stackTrace) => Text('$error'),
        loading: () => const CircularProgressIndicator(color: Colors.red),
      ),
    );
  }
}
