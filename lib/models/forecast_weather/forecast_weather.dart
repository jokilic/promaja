import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'forecast_day_weather.dart';

class ForecastWeather {
  final List<ForecastDayWeather> forecastDays;

  ForecastWeather({
    required this.forecastDays,
  });

  ForecastWeather copyWith({
    List<ForecastDayWeather>? forecastDays,
  }) =>
      ForecastWeather(
        forecastDays: forecastDays ?? this.forecastDays,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'forecastday': forecastDays.map((x) => x.toMap()).toList(),
      };

  factory ForecastWeather.fromMap(Map<String, dynamic> map) => ForecastWeather(
        forecastDays: List<ForecastDayWeather>.from(
          (map['forecastday'] as List<dynamic>).map<ForecastDayWeather>(
            (x) => ForecastDayWeather.fromMap(x as Map<String, dynamic>),
          ),
        ),
      );

  String toJson() => json.encode(toMap());

  factory ForecastWeather.fromJson(String source) => ForecastWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ForecastWeather(forecastDays: $forecastDays)';

  @override
  bool operator ==(covariant ForecastWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return listEquals(other.forecastDays, forecastDays);
  }

  @override
  int get hashCode => forecastDays.hashCode;
}
