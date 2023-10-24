import 'dart:convert';

import '../current_weather/current_weather.dart';
import '../location/location.dart';
import 'forecast_weather.dart';

class ResponseForecastWeather {
  final Location location;
  final CurrentWeather current;
  final ForecastWeather forecast;

  ResponseForecastWeather({
    required this.location,
    required this.current,
    required this.forecast,
  });

  ResponseForecastWeather copyWith({
    Location? location,
    CurrentWeather? current,
    ForecastWeather? forecast,
  }) =>
      ResponseForecastWeather(
        location: location ?? this.location,
        current: current ?? this.current,
        forecast: forecast ?? this.forecast,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'location': location.toMap(),
        'current': current.toMap(),
        'forecast': forecast.toMap(),
      };

  factory ResponseForecastWeather.fromMap(Map<String, dynamic> map) => ResponseForecastWeather(
        location: Location.fromMap(map['location'] as Map<String, dynamic>),
        current: CurrentWeather.fromMap(map['current'] as Map<String, dynamic>),
        forecast: ForecastWeather.fromMap(map['forecast'] as Map<String, dynamic>),
      );

  String toJson() => json.encode(toMap());

  factory ResponseForecastWeather.fromJson(String source) => ResponseForecastWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ResponseForecastWeather(location: $location, current: $current, forecast: $forecast)';

  @override
  bool operator ==(covariant ResponseForecastWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.location == location && other.current == current && other.forecast == forecast;
  }

  @override
  int get hashCode => location.hashCode ^ current.hashCode ^ forecast.hashCode;
}
