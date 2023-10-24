import 'package:flutter/material.dart';

import '../../../../models/location/location.dart';

// TODO: Finish this
class WeatherError extends StatelessWidget {
  final Location location;
  final String error;

  const WeatherError({
    required this.location,
    required this.error,
  });

  @override
  Widget build(BuildContext context) => const Placeholder();
}
