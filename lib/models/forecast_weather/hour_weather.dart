import 'dart:convert';

import '../current_weather/condition.dart';

class HourWeather {
  final DateTime timeEpoch;
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
  final int willItRain;
  final int chanceOfRain;
  final double visKm;
  final double gustKph;
  final double uv;

  HourWeather({
    required this.timeEpoch,
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
    required this.willItRain,
    required this.chanceOfRain,
    required this.visKm,
    required this.gustKph,
    required this.uv,
  });

  HourWeather copyWith({
    DateTime? timeEpoch,
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
    int? willItRain,
    int? chanceOfRain,
    double? visKm,
    double? gustKph,
    double? uv,
  }) =>
      HourWeather(
        timeEpoch: timeEpoch ?? this.timeEpoch,
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
        willItRain: willItRain ?? this.willItRain,
        chanceOfRain: chanceOfRain ?? this.chanceOfRain,
        visKm: visKm ?? this.visKm,
        gustKph: gustKph ?? this.gustKph,
        uv: uv ?? this.uv,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'time_epoch': timeEpoch.millisecondsSinceEpoch,
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
        'will_it_rain': willItRain,
        'chance_of_rain': chanceOfRain,
        'vis_km': visKm,
        'gust_kph': gustKph,
        'uv': uv,
      };

  factory HourWeather.fromMap(Map<String, dynamic> map) => HourWeather(
        timeEpoch: DateTime.fromMillisecondsSinceEpoch((map['time_epoch'] as int) * 1000),
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
        willItRain: map['will_it_rain'] as int,
        chanceOfRain: map['chance_of_rain'] as int,
        visKm: map['vis_km'] as double,
        gustKph: map['gust_kph'] as double,
        uv: map['uv'] as double,
      );

  String toJson() => json.encode(toMap());

  factory HourWeather.fromJson(String source) => HourWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'HourWeather(timeEpoch: $timeEpoch, tempC: $tempC, isDay: $isDay, condition: $condition, windKph: $windKph, windDegree: $windDegree, pressurehPa: $pressurehPa, precipMm: $precipMm, humidity: $humidity, cloud: $cloud, feelsLikeC: $feelsLikeC, willItRain: $willItRain, chanceOfRain: $chanceOfRain, visKm: $visKm, gustKph: $gustKph, uv: $uv)';

  @override
  bool operator ==(covariant HourWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.timeEpoch == timeEpoch &&
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
        other.willItRain == willItRain &&
        other.chanceOfRain == chanceOfRain &&
        other.visKm == visKm &&
        other.gustKph == gustKph &&
        other.uv == uv;
  }

  @override
  int get hashCode =>
      timeEpoch.hashCode ^
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
      willItRain.hashCode ^
      chanceOfRain.hashCode ^
      visKm.hashCode ^
      gustKph.hashCode ^
      uv.hashCode;
}
