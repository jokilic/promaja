import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'weather_controller.dart';

class WeatherScreen extends GetView<WeatherController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Hello'),
        ),
        body: Scaffold(
          body: Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.backup_rounded),
              label: const Text('Fetch weather'),
            ),
          ),
        ),
      );
}
