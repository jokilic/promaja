import 'package:flutter/material.dart';

import '../constants/enums.dart';

///
/// Checks device language code against `OpenWeatherMap` language codes
/// If language code is found, it's used as a query parameter when fetching weather
///
String? getLangQueryParameter(BuildContext context) {
  final languageCode = Localizations.localeOf(context).languageCode;
  return ResponseLanguage.values.byName(languageCode).name;
}
