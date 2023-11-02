import 'package:flutter/material.dart';

import '../../../../models/location/location.dart';

// TODO: Finish this
class WeatherCardError extends StatelessWidget {
  final Location location;
  final bool useOpacity;
  final String error;

  const WeatherCardError({
    required this.location,
    required this.useOpacity,
    required this.error,
    super.key,
  });

  @override
  Widget build(BuildContext context) => const Placeholder();
}
