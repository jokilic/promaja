import 'dart:convert';

import '../condition/condition.dart';

class DayWeather {
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final int dailyWillItRain;
  final int dailyChanceOfRain;
  final int dailyWillItSnow;
  final int dailyChanceOfSnow;
  final Condition condition;

  DayWeather({
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
  });

  DayWeather copyWith({
    double? maxTempC,
    double? maxTempF,
    double? minTempC,
    double? minTempF,
    int? dailyWillItRain,
    int? dailyChanceOfRain,
    int? dailyWillItSnow,
    int? dailyChanceOfSnow,
    Condition? condition,
  }) =>
      DayWeather(
        maxTempC: maxTempC ?? this.maxTempC,
        maxTempF: maxTempF ?? this.maxTempF,
        minTempC: minTempC ?? this.minTempC,
        minTempF: minTempF ?? this.minTempF,
        dailyWillItRain: dailyWillItRain ?? this.dailyWillItRain,
        dailyChanceOfRain: dailyChanceOfRain ?? this.dailyChanceOfRain,
        dailyWillItSnow: dailyWillItSnow ?? this.dailyWillItSnow,
        dailyChanceOfSnow: dailyChanceOfSnow ?? this.dailyChanceOfSnow,
        condition: condition ?? this.condition,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'maxtemp_c': maxTempC,
        'maxtemp_f': maxTempF,
        'mintemp_c': minTempC,
        'mintemp_f': minTempF,
        'daily_will_it_rain': dailyWillItRain,
        'daily_chance_of_rain': dailyChanceOfRain,
        'daily_will_it_snow': dailyWillItSnow,
        'daily_chance_of_snow': dailyChanceOfSnow,
        'condition': condition.toMap(),
      };

  factory DayWeather.fromMap(Map<String, dynamic> map) => DayWeather(
        maxTempC: map['maxtemp_c'] as double,
        maxTempF: map['maxtemp_f'] as double,
        minTempC: map['mintemp_c'] as double,
        minTempF: map['mintemp_f'] as double,
        dailyWillItRain: map['daily_will_it_rain'] as int,
        dailyChanceOfRain: map['daily_chance_of_rain'] as int,
        dailyWillItSnow: map['daily_will_it_snow'] as int,
        dailyChanceOfSnow: map['daily_chance_of_snow'] as int,
        condition: Condition.fromMap(map['condition'] as Map<String, dynamic>),
      );

  String toJson() => json.encode(toMap());

  factory DayWeather.fromJson(String source) => DayWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DayWeather(maxTempC: $maxTempC, maxTempF: $maxTempF, minTempC: $minTempC, minTempF: $minTempF, dailyWillItRain: $dailyWillItRain, dailyChanceOfRain: $dailyChanceOfRain, dailyWillItSnow: $dailyWillItSnow, dailyChanceOfSnow: $dailyChanceOfSnow, condition: $condition)';

  @override
  bool operator ==(covariant DayWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.maxTempC == maxTempC &&
        other.maxTempF == maxTempF &&
        other.minTempC == minTempC &&
        other.minTempF == minTempF &&
        other.dailyWillItRain == dailyWillItRain &&
        other.dailyChanceOfRain == dailyChanceOfRain &&
        other.dailyWillItSnow == dailyWillItSnow &&
        other.dailyChanceOfSnow == dailyChanceOfSnow &&
        other.condition == condition;
  }

  @override
  int get hashCode =>
      maxTempC.hashCode ^
      maxTempF.hashCode ^
      minTempC.hashCode ^
      minTempF.hashCode ^
      dailyWillItRain.hashCode ^
      dailyChanceOfRain.hashCode ^
      dailyWillItSnow.hashCode ^
      dailyChanceOfSnow.hashCode ^
      condition.hashCode;
}
