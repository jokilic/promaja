import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cities/cities_controller.dart';

class WeatherScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesController = ref.watch(citiesProvider(context));

    return Scaffold(
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
}
