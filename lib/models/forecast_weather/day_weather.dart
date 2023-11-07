import 'dart:convert';

import '../current_weather/condition.dart';

class DayWeather {
  final double maxTempC;
  final double minTempC;
  final Condition condition;

  DayWeather({
    required this.maxTempC,
    required this.minTempC,
    required this.condition,
  });

  DayWeather copyWith({
    double? maxTempC,
    double? minTempC,
    Condition? condition,
  }) =>
      DayWeather(
        maxTempC: maxTempC ?? this.maxTempC,
        minTempC: minTempC ?? this.minTempC,
        condition: condition ?? this.condition,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'maxtemp_c': maxTempC,
        'mintemp_c': minTempC,
        'condition': condition.toMap(),
      };

  factory DayWeather.fromMap(Map<String, dynamic> map) => DayWeather(
        maxTempC: map['maxtemp_c'] as double,
        minTempC: map['mintemp_c'] as double,
        condition: Condition.fromMap(map['condition'] as Map<String, dynamic>),
      );

  String toJson() => json.encode(toMap());

  factory DayWeather.fromJson(String source) => DayWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DayWeather(maxTempC: $maxTempC, minTempC: $minTempC, condition: $condition)';

  @override
  bool operator ==(covariant DayWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.maxTempC == maxTempC && other.minTempC == minTempC && other.condition == condition;
  }

  @override
  int get hashCode => maxTempC.hashCode ^ minTempC.hashCode ^ condition.hashCode;
}
