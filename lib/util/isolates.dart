import 'package:flutter/foundation.dart';

import '../models/current_weather/response_current_weather.dart';

/// Used to parse `current weather` using isolates
Future<ResponseCurrentWeather> computeCurrentWeather(data) async => compute(parseCurrentWeather, data);
ResponseCurrentWeather parseCurrentWeather(data) => ResponseCurrentWeather.fromMap(data);
