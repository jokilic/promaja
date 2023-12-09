import 'dart:convert';

import '../condition/condition.dart';

class CurrentWeather {
  final DateTime lastUpdatedEpoch;
  final double tempC;
  final int isDay;
  final Condition condition;
  final double windKph;
  final int windDegree;
  final double pressurehPa;
  final double precipMm;
  final int humidity;
  final int cloud;
  final double feelsLikeC;
  final double visKm;
  final double uv;
  final double gustKph;

  CurrentWeather({
    required this.lastUpdatedEpoch,
    required this.tempC,
    required this.isDay,
    required this.condition,
    required this.windKph,
    required this.windDegree,
    required this.pressurehPa,
    required this.precipMm,
    required this.humidity,
    required this.cloud,
    required this.feelsLikeC,
    required this.visKm,
    required this.uv,
    required this.gustKph,
  });

  CurrentWeather copyWith({
    DateTime? lastUpdatedEpoch,
    double? tempC,
    int? isDay,
    Condition? condition,
    double? windKph,
    int? windDegree,
    double? pressurehPa,
    double? precipMm,
    int? humidity,
    int? cloud,
    double? feelsLikeC,
    double? visKm,
    double? uv,
    double? gustKph,
  }) =>
      CurrentWeather(
        lastUpdatedEpoch: lastUpdatedEpoch ?? this.lastUpdatedEpoch,
        tempC: tempC ?? this.tempC,
        isDay: isDay ?? this.isDay,
        condition: condition ?? this.condition,
        windKph: windKph ?? this.windKph,
        windDegree: windDegree ?? this.windDegree,
        pressurehPa: pressurehPa ?? this.pressurehPa,
        precipMm: precipMm ?? this.precipMm,
        humidity: humidity ?? this.humidity,
        cloud: cloud ?? this.cloud,
        feelsLikeC: feelsLikeC ?? this.feelsLikeC,
        visKm: visKm ?? this.visKm,
        uv: uv ?? this.uv,
        gustKph: gustKph ?? this.gustKph,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'last_updated_epoch': lastUpdatedEpoch.millisecondsSinceEpoch,
        'temp_c': tempC,
        'is_day': isDay,
        'condition': condition.toMap(),
        'wind_kph': windKph,
        'wind_degree': windDegree,
        'pressure_mb': pressurehPa,
        'precip_mm': precipMm,
        'humidity': humidity,
        'cloud': cloud,
        'feelslike_c': feelsLikeC,
        'vis_km': visKm,
        'uv': uv,
        'gust_kph': gustKph,
      };

  factory CurrentWeather.fromMap(Map<String, dynamic> map) => CurrentWeather(
        lastUpdatedEpoch: DateTime.fromMillisecondsSinceEpoch((map['last_updated_epoch'] as int) * 1000),
        tempC: map['temp_c'] as double,
        isDay: map['is_day'] as int,
        condition: Condition.fromMap(map['condition'] as Map<String, dynamic>),
        windKph: map['wind_kph'] as double,
        windDegree: map['wind_degree'] as int,
        pressurehPa: map['pressure_mb'] as double,
        precipMm: map['precip_mm'] as double,
        humidity: map['humidity'] as int,
        cloud: map['cloud'] as int,
        feelsLikeC: map['feelslike_c'] as double,
        visKm: map['vis_km'] as double,
        uv: map['uv'] as double,
        gustKph: map['gust_kph'] as double,
      );

  String toJson() => json.encode(toMap());

  factory CurrentWeather.fromJson(String source) => CurrentWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CurrentWeather(lastUpdatedEpoch: $lastUpdatedEpoch, tempC: $tempC, isDay: $isDay, condition: $condition, windKph: $windKph, windDegree: $windDegree, pressurehPa: $pressurehPa, precipMm: $precipMm, humidity: $humidity, cloud: $cloud, feelsLikeC: $feelsLikeC, visKm: $visKm, uv: $uv, gustKph: $gustKph)';

  @override
  bool operator ==(covariant CurrentWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.lastUpdatedEpoch == lastUpdatedEpoch &&
        other.tempC == tempC &&
        other.isDay == isDay &&
        other.condition == condition &&
        other.windKph == windKph &&
        other.windDegree == windDegree &&
        other.pressurehPa == pressurehPa &&
        other.precipMm == precipMm &&
        other.humidity == humidity &&
        other.cloud == cloud &&
        other.feelsLikeC == feelsLikeC &&
        other.visKm == visKm &&
        other.uv == uv &&
        other.gustKph == gustKph;
  }

  @override
  int get hashCode =>
      lastUpdatedEpoch.hashCode ^
      tempC.hashCode ^
      isDay.hashCode ^
      condition.hashCode ^
      windKph.hashCode ^
      windDegree.hashCode ^
      pressurehPa.hashCode ^
      precipMm.hashCode ^
      humidity.hashCode ^
      cloud.hashCode ^
      feelsLikeC.hashCode ^
      visKm.hashCode ^
      uv.hashCode ^
      gustKph.hashCode;
}
