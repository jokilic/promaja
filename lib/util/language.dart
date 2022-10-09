import 'package:get/get.dart';

import '../constants/enums.dart';

///
/// Checks device language code against `OpenWeatherMap` language codes
/// If language code is found, it's used as a query parameter when fetching weather
///
String? getLangQueryParameter() {
  late String? lang;

  try {
    if (Get.deviceLocale != null) {
      final languageCode = Get.deviceLocale!.languageCode;
      lang = ResponseLanguage.values.byName(languageCode).name;
    }
  } catch (e) {
    lang = null;
  }

  return lang;
}
