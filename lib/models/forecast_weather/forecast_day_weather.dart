import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'day_weather.dart';
import 'hour_weather.dart';

class ForecastDayWeather {
  final DateTime dateEpoch;
  final DayWeather day;
  final List<HourWeather> hours;

  ForecastDayWeather({
    required this.dateEpoch,
    required this.day,
    required this.hours,
  });

  ForecastDayWeather copyWith({
    DateTime? dateEpoch,
    DayWeather? day,
    List<HourWeather>? hours,
  }) =>
      ForecastDayWeather(
        dateEpoch: dateEpoch ?? this.dateEpoch,
        day: day ?? this.day,
        hours: hours ?? this.hours,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'date_epoch': dateEpoch.millisecondsSinceEpoch,
        'day': day.toMap(),
        'hour': hours.map((x) => x.toMap()).toList(),
      };

  factory ForecastDayWeather.fromMap(Map<String, dynamic> map) => ForecastDayWeather(
        dateEpoch: DateTime.fromMillisecondsSinceEpoch((map['date_epoch'] as int) * 1000),
        day: DayWeather.fromMap(map['day'] as Map<String, dynamic>),
        hours: List<HourWeather>.from(
          (map['hour'] as List<dynamic>).map<HourWeather>(
            (x) => HourWeather.fromMap(x as Map<String, dynamic>),
          ),
        ),
      );

  String toJson() => json.encode(toMap());

  factory ForecastDayWeather.fromJson(String source) => ForecastDayWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ForecastDayWeather(dateEpoch: $dateEpoch, day: $day, hours: $hours)';

  @override
  bool operator ==(covariant ForecastDayWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.dateEpoch == dateEpoch && other.day == day && listEquals(other.hours, hours);
  }

  @override
  int get hashCode => dateEpoch.hashCode ^ day.hashCode ^ hours.hashCode;
}
