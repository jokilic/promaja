import 'package:flutter/foundation.dart';

import '../models/current_weather/response_current_weather.dart';

///
/// Here we have all functionality which uses Dart isolates
/// They are declared as global functions
///

///
/// Used to parse `current weather` using isolates
///
Future<ResponseCurrentWeather> computeCurrentWeather(data) async => compute(parseCurrentWeather, data);
ResponseCurrentWeather parseCurrentWeather(data) => ResponseCurrentWeather.fromMap(data);
