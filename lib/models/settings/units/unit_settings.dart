import 'dart:convert';

import 'package:hive/hive.dart';

import 'distance_speed_unit.dart';
import 'precipitation_unit.dart';
import 'pressure_unit.dart';
import 'temperature_unit.dart';

part 'unit_settings.g.dart';

@HiveType(typeId: 8)
class UnitSettings extends HiveObject {
  @HiveField(0)
  final TemperatureUnit temperature;
  @HiveField(1)
  final DistanceSpeedUnit distanceSpeed;
  @HiveField(2)
  final PrecipitationUnit precipitation;
  @HiveField(3)
  final PressureUnit pressure;

  UnitSettings({
    required this.temperature,
    required this.distanceSpeed,
    required this.precipitation,
    required this.pressure,
  });

  UnitSettings copyWith({
    TemperatureUnit? temperature,
    DistanceSpeedUnit? distanceSpeed,
    PrecipitationUnit? precipitation,
    PressureUnit? pressure,
  }) =>
      UnitSettings(
        temperature: temperature ?? this.temperature,
        distanceSpeed: distanceSpeed ?? this.distanceSpeed,
        precipitation: precipitation ?? this.precipitation,
        pressure: pressure ?? this.pressure,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'temperature': temperature.name,
        'distanceSpeed': distanceSpeed.name,
        'precipitation': precipitation.name,
        'pressure': pressure.name,
      };

  factory UnitSettings.fromMap(Map<String, dynamic> map) => UnitSettings(
        temperature: TemperatureUnit.values.byName(map['temperature'] as String),
        distanceSpeed: DistanceSpeedUnit.values.byName(map['distanceSpeed'] as String),
        precipitation: PrecipitationUnit.values.byName(map['precipitation'] as String),
        pressure: PressureUnit.values.byName(map['pressure'] as String),
      );

  String toJson() => json.encode(toMap());

  factory UnitSettings.fromJson(String source) => UnitSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UnitSettings(temperature: $temperature, distanceSpeed: $distanceSpeed, precipitation: $precipitation, pressure: $pressure)';

  @override
  bool operator ==(covariant UnitSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.temperature == temperature && other.distanceSpeed == distanceSpeed && other.precipitation == precipitation && other.pressure == pressure;
  }

  @override
  int get hashCode => temperature.hashCode ^ distanceSpeed.hashCode ^ precipitation.hashCode ^ pressure.hashCode;
}
