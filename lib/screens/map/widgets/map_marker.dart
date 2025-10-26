import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/icons.dart';
import '../../../models/location/location.dart';

class MapMarker extends StatelessWidget {
  final Location location;

  const MapMarker({
    required this.location,
  });

  @override
  Widget build(BuildContext context) => Image.asset(
    PromajaIcons.pin,
    color: PromajaColors.black,
    height: 24,
    width: 24,
  );
}
