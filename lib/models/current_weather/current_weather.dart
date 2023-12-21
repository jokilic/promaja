import 'dart:convert';

import '../condition/condition.dart';

class CurrentWeather {
  final DateTime lastUpdatedEpoch;
  final double tempC;
  final double tempF;
  final int isDay;
  final Condition condition;
  final double windKph;
  final double windMph;
  final int windDegree;
  final double pressurehPa;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final int humidity;
  final int cloud;
  final double feelsLikeC;
  final double feelsLikeF;
  final double visKm;
  final double visMiles;
  final double uv;
  final double gustKph;
  final double gustMph;

  CurrentWeather({
    required this.lastUpdatedEpoch,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windKph,
    required this.windMph,
    required this.windDegree,
    required this.pressurehPa,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustKph,
    required this.gustMph,
  });

  CurrentWeather copyWith({
    DateTime? lastUpdatedEpoch,
    double? tempC,
    double? tempF,
    int? isDay,
    Condition? condition,
    double? windKph,
    double? windMph,
    int? windDegree,
    double? pressurehPa,
    double? pressureIn,
    double? precipMm,
    double? precipIn,
    int? humidity,
    int? cloud,
    double? feelsLikeC,
    double? feelsLikeF,
    double? visKm,
    double? visMiles,
    double? uv,
    double? gustKph,
    double? gustMph,
  }) =>
      CurrentWeather(
        lastUpdatedEpoch: lastUpdatedEpoch ?? this.lastUpdatedEpoch,
        tempC: tempC ?? this.tempC,
        tempF: tempF ?? this.tempF,
        isDay: isDay ?? this.isDay,
        condition: condition ?? this.condition,
        windKph: windKph ?? this.windKph,
        windMph: windMph ?? this.windMph,
        windDegree: windDegree ?? this.windDegree,
        pressurehPa: pressurehPa ?? this.pressurehPa,
        pressureIn: pressureIn ?? this.pressureIn,
        precipMm: precipMm ?? this.precipMm,
        precipIn: precipIn ?? this.precipIn,
        humidity: humidity ?? this.humidity,
        cloud: cloud ?? this.cloud,
        feelsLikeC: feelsLikeC ?? this.feelsLikeC,
        feelsLikeF: feelsLikeF ?? this.feelsLikeF,
        visKm: visKm ?? this.visKm,
        visMiles: visMiles ?? this.visMiles,
        uv: uv ?? this.uv,
        gustKph: gustKph ?? this.gustKph,
        gustMph: gustMph ?? this.gustMph,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'last_updated_epoch': lastUpdatedEpoch.millisecondsSinceEpoch,
        'temp_c': tempC,
        'temp_f': tempF,
        'is_day': isDay,
        'condition': condition.toMap(),
        'wind_kph': windKph,
        'wind_mph': windMph,
        'wind_degree': windDegree,
        'pressure_mb': pressurehPa,
        'pressure_in': pressureIn,
        'precip_mm': precipMm,
        'precip_in': precipIn,
        'humidity': humidity,
        'cloud': cloud,
        'feelslike_c': feelsLikeC,
        'feelslike_f': feelsLikeF,
        'vis_km': visKm,
        'vis_miles': visMiles,
        'uv': uv,
        'gust_kph': gustKph,
        'gust_mph': gustMph,
      };

  factory CurrentWeather.fromMap(Map<String, dynamic> map) => CurrentWeather(
        lastUpdatedEpoch: DateTime.fromMillisecondsSinceEpoch((map['last_updated_epoch'] as int) * 1000),
        tempC: map['temp_c'] as double,
        tempF: map['temp_f'] as double,
        isDay: map['is_day'] as int,
        condition: Condition.fromMap(map['condition'] as Map<String, dynamic>),
        windKph: map['wind_kph'] as double,
        windMph: map['wind_mph'] as double,
        windDegree: map['wind_degree'] as int,
        pressurehPa: map['pressure_mb'] as double,
        pressureIn: map['pressure_in'] as double,
        precipMm: map['precip_mm'] as double,
        precipIn: map['precip_in'] as double,
        humidity: map['humidity'] as int,
        cloud: map['cloud'] as int,
        feelsLikeC: map['feelslike_c'] as double,
        feelsLikeF: map['feelslike_f'] as double,
        visKm: map['vis_km'] as double,
        visMiles: map['vis_miles'] as double,
        uv: map['uv'] as double,
        gustKph: map['gust_kph'] as double,
        gustMph: map['gust_mph'] as double,
      );

  String toJson() => json.encode(toMap());

  factory CurrentWeather.fromJson(String source) => CurrentWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CurrentWeather(lastUpdatedEpoch: $lastUpdatedEpoch, tempC: $tempC, tempF: $tempF, isDay: $isDay, condition: $condition, windKph: $windKph, windMph: $windMph, windDegree: $windDegree, pressurehPa: $pressurehPa, pressureIn: $pressureIn, precipMm: $precipMm, precipIn: $precipIn, humidity: $humidity, cloud: $cloud, feelsLikeC: $feelsLikeC, feelsLikeF: $feelsLikeF, visKm: $visKm, visMiles: $visMiles, uv: $uv, gustKph: $gustKph, gustMph: $gustMph)';

  @override
  bool operator ==(covariant CurrentWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.lastUpdatedEpoch == lastUpdatedEpoch &&
        other.tempC == tempC &&
        other.tempF == tempF &&
        other.isDay == isDay &&
        other.condition == condition &&
        other.windKph == windKph &&
        other.windMph == windMph &&
        other.windDegree == windDegree &&
        other.pressurehPa == pressurehPa &&
        other.pressureIn == pressureIn &&
        other.precipMm == precipMm &&
        other.precipIn == precipIn &&
        other.humidity == humidity &&
        other.cloud == cloud &&
        other.feelsLikeC == feelsLikeC &&
        other.feelsLikeF == feelsLikeF &&
        other.visKm == visKm &&
        other.visMiles == visMiles &&
        other.uv == uv &&
        other.gustKph == gustKph &&
        other.gustMph == gustMph;
  }

  @override
  int get hashCode =>
      lastUpdatedEpoch.hashCode ^
      tempC.hashCode ^
      tempF.hashCode ^
      isDay.hashCode ^
      condition.hashCode ^
      windKph.hashCode ^
      windMph.hashCode ^
      windDegree.hashCode ^
      pressurehPa.hashCode ^
      pressureIn.hashCode ^
      precipMm.hashCode ^
      precipIn.hashCode ^
      humidity.hashCode ^
      cloud.hashCode ^
      feelsLikeC.hashCode ^
      feelsLikeF.hashCode ^
      visKm.hashCode ^
      visMiles.hashCode ^
      uv.hashCode ^
      gustKph.hashCode ^
      gustMph.hashCode;
}
