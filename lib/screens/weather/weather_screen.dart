import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'weather_controller.dart';

class WeatherScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchWeather = ref.watch(fetchWeatherProvider(context));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
      ),
      body: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.backup_rounded),
                label: const Text('Fetch weather'),
              ),
              SizedBox(height: 24.h),
              fetchWeather.when(
                data: (weather) => Text('${weather?.main.temp}'),
                error: (error, stackTrace) => Text('$error'),
                loading: () => const CircularProgressIndicator(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
