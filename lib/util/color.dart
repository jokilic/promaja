// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

Color darkenColor(Color color, {double factor = 0.2}) {
  // Calculate new channel values
  final red = (color.red * (1 - factor)).round();
  final green = (color.green * (1 - factor)).round();
  final blue = (color.blue * (1 - factor)).round();

  // Create and return the new color
  return Color.fromRGBO(red, green, blue, 1);
}

Color lightenColor(Color color, {double factor = 0.2}) {
  // Calculate new channel values
  final red = (color.red + (255 - color.red) * factor).round();
  final green = (color.green + (255 - color.green) * factor).round();
  final blue = (color.blue + (255 - color.blue) * factor).round();

  // Create and return the new color
  return Color.fromRGBO(red, green, blue, 1);
}
