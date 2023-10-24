import 'dart:convert';

import '../current_weather/condition.dart';

class DayWeather {
  final double maxTempC;
  final double minTempC;
  final double avgTempC;
  final double maxWindKph;
  final double totalPrecipMm;
  final double avgVisKm;
  final double avgHumidity;
  final Condition condition;
  final double uv;

  DayWeather({
    required this.maxTempC,
    required this.minTempC,
    required this.avgTempC,
    required this.maxWindKph,
    required this.totalPrecipMm,
    required this.avgVisKm,
    required this.avgHumidity,
    required this.condition,
    required this.uv,
  });

  DayWeather copyWith({
    double? maxTempC,
    double? minTempC,
    double? avgTempC,
    double? maxWindKph,
    double? totalPrecipMm,
    double? avgVisKm,
    double? avgHumidity,
    Condition? condition,
    double? uv,
  }) =>
      DayWeather(
        maxTempC: maxTempC ?? this.maxTempC,
        minTempC: minTempC ?? this.minTempC,
        avgTempC: avgTempC ?? this.avgTempC,
        maxWindKph: maxWindKph ?? this.maxWindKph,
        totalPrecipMm: totalPrecipMm ?? this.totalPrecipMm,
        avgVisKm: avgVisKm ?? this.avgVisKm,
        avgHumidity: avgHumidity ?? this.avgHumidity,
        condition: condition ?? this.condition,
        uv: uv ?? this.uv,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'maxtemp_c': maxTempC,
        'mintemp_c': minTempC,
        'avgtemp_c': avgTempC,
        'maxwind_kph': maxWindKph,
        'totalprecip_mm': totalPrecipMm,
        'avgvis_km': avgVisKm,
        'avghumidity': avgHumidity,
        'condition': condition.toMap(),
        'uv': uv,
      };

  factory DayWeather.fromMap(Map<String, dynamic> map) => DayWeather(
        maxTempC: map['maxtemp_c'] as double,
        minTempC: map['mintemp_c'] as double,
        avgTempC: map['avgtemp_c'] as double,
        maxWindKph: map['maxwind_kph'] as double,
        totalPrecipMm: map['totalprecip_mm'] as double,
        avgVisKm: map['avgvis_km'] as double,
        avgHumidity: map['avghumidity'] as double,
        condition: Condition.fromMap(map['condition'] as Map<String, dynamic>),
        uv: map['uv'] as double,
      );

  String toJson() => json.encode(toMap());

  factory DayWeather.fromJson(String source) => DayWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DayWeather(maxTempC: $maxTempC, minTempC: $minTempC, avgTempC: $avgTempC, maxWindKph: $maxWindKph, totalPrecipMm: $totalPrecipMm, avgVisKm: $avgVisKm, avgHumidity: $avgHumidity, condition: $condition, uv: $uv)';

  @override
  bool operator ==(covariant DayWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.maxTempC == maxTempC &&
        other.minTempC == minTempC &&
        other.avgTempC == avgTempC &&
        other.maxWindKph == maxWindKph &&
        other.totalPrecipMm == totalPrecipMm &&
        other.avgVisKm == avgVisKm &&
        other.avgHumidity == avgHumidity &&
        other.condition == condition &&
        other.uv == uv;
  }

  @override
  int get hashCode =>
      maxTempC.hashCode ^
      minTempC.hashCode ^
      avgTempC.hashCode ^
      maxWindKph.hashCode ^
      totalPrecipMm.hashCode ^
      avgVisKm.hashCode ^
      avgHumidity.hashCode ^
      condition.hashCode ^
      uv.hashCode;
}
