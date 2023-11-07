import 'dart:convert';

import '../current_weather/condition.dart';

class DayWeather {
  final double maxTempC;
  final double minTempC;
  final int dailyWillItRain;
  final int dailyChanceOfRain;
  final Condition condition;

  DayWeather({
    required this.maxTempC,
    required this.minTempC,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.condition,
  });

  DayWeather copyWith({
    double? maxTempC,
    double? minTempC,
    int? dailyWillItRain,
    int? dailyChanceOfRain,
    Condition? condition,
  }) =>
      DayWeather(
        maxTempC: maxTempC ?? this.maxTempC,
        minTempC: minTempC ?? this.minTempC,
        dailyWillItRain: dailyWillItRain ?? this.dailyWillItRain,
        dailyChanceOfRain: dailyChanceOfRain ?? this.dailyChanceOfRain,
        condition: condition ?? this.condition,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'maxtemp_c': maxTempC,
        'mintemp_c': minTempC,
        'daily_will_it_rain': dailyWillItRain,
        'daily_chance_of_rain': dailyChanceOfRain,
        'condition': condition.toMap(),
      };

  factory DayWeather.fromMap(Map<String, dynamic> map) => DayWeather(
        maxTempC: map['maxtemp_c'] as double,
        minTempC: map['mintemp_c'] as double,
        dailyWillItRain: map['daily_will_it_rain'] as int,
        dailyChanceOfRain: map['daily_chance_of_rain'] as int,
        condition: Condition.fromMap(map['condition'] as Map<String, dynamic>),
      );

  String toJson() => json.encode(toMap());

  factory DayWeather.fromJson(String source) => DayWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DayWeather(maxTempC: $maxTempC, minTempC: $minTempC, dailyWillItRain: $dailyWillItRain, dailyChanceOfRain: $dailyChanceOfRain, condition: $condition)';

  @override
  bool operator ==(covariant DayWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.maxTempC == maxTempC &&
        other.minTempC == minTempC &&
        other.dailyWillItRain == dailyWillItRain &&
        other.dailyChanceOfRain == dailyChanceOfRain &&
        other.condition == condition;
  }

  @override
  int get hashCode => maxTempC.hashCode ^ minTempC.hashCode ^ dailyWillItRain.hashCode ^ dailyChanceOfRain.hashCode ^ condition.hashCode;
}
