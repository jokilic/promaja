import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cities_controller.dart';

class CitiesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesController = ref.watch(citiesProvider(context));

    return const Scaffold();
  }
}
