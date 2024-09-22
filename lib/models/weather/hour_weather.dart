import '../condition/condition.dart';

class HourWeather {
  final DateTime timeEpoch;
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
  final int willItRain;
  final int chanceOfRain;
  final int willItSnow;
  final int chanceOfSnow;
  final double visKm;
  final double visMiles;
  final double gustKph;
  final double gustMph;
  final double uv;

  HourWeather({
    required this.timeEpoch,
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
    required this.willItRain,
    required this.chanceOfRain,
    required this.willItSnow,
    required this.chanceOfSnow,
    required this.visKm,
    required this.visMiles,
    required this.gustKph,
    required this.gustMph,
    required this.uv,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'time_epoch': timeEpoch.millisecondsSinceEpoch,
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
        'will_it_rain': willItRain,
        'chance_of_rain': chanceOfRain,
        'will_it_snow': willItSnow,
        'chance_of_snow': chanceOfSnow,
        'vis_km': visKm,
        'vis_miles': visMiles,
        'gust_kph': gustKph,
        'gust_mph': gustMph,
        'uv': uv,
      };

  factory HourWeather.fromMap(Map<String, dynamic> map) => HourWeather(
        timeEpoch: DateTime.fromMillisecondsSinceEpoch((map['time_epoch'] as int) * 1000),
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
        willItRain: map['will_it_rain'] as int,
        chanceOfRain: map['chance_of_rain'] as int,
        willItSnow: map['will_it_snow'] as int,
        chanceOfSnow: map['chance_of_snow'] as int,
        visKm: map['vis_km'] as double,
        visMiles: map['vis_miles'] as double,
        gustKph: map['gust_kph'] as double,
        gustMph: map['gust_mph'] as double,
        uv: (map['uv'] is int) ? (map['uv'] as int).toDouble() : map['uv'] as double,
      );

  @override
  String toString() =>
      'HourWeather(timeEpoch: $timeEpoch, tempC: $tempC, tempF: $tempF, isDay: $isDay, condition: $condition, windKph: $windKph, windMph: $windMph, windDegree: $windDegree, pressurehPa: $pressurehPa, pressureIn: $pressureIn, precipMm: $precipMm, precipIn: $precipIn, humidity: $humidity, cloud: $cloud, feelsLikeC: $feelsLikeC, feelsLikeF: $feelsLikeF, willItRain: $willItRain, chanceOfRain: $chanceOfRain, willItSnow: $willItSnow, chanceOfSnow: $chanceOfSnow, visKm: $visKm, visMiles: $visMiles, gustKph: $gustKph, gustMph: $gustMph, uv: $uv)';

  @override
  bool operator ==(covariant HourWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.timeEpoch == timeEpoch &&
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
        other.willItRain == willItRain &&
        other.chanceOfRain == chanceOfRain &&
        other.willItSnow == willItSnow &&
        other.chanceOfSnow == chanceOfSnow &&
        other.visKm == visKm &&
        other.visMiles == visMiles &&
        other.gustKph == gustKph &&
        other.gustMph == gustMph &&
        other.uv == uv;
  }

  @override
  int get hashCode =>
      timeEpoch.hashCode ^
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
      willItRain.hashCode ^
      chanceOfRain.hashCode ^
      willItSnow.hashCode ^
      chanceOfSnow.hashCode ^
      visKm.hashCode ^
      visMiles.hashCode ^
      gustKph.hashCode ^
      gustMph.hashCode ^
      uv.hashCode;
}
