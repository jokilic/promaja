// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'clouds.dart';
import 'coord.dart';
import 'main.dart';
import 'sys.dart';
import 'weather.dart';
import 'wind.dart';

class ResponseCurrentWeather {
  final Coord coord;
  final List<Weather> weather;
  final String base;
  final Main main;
  final int visibility;
  final Wind wind;
  final Clouds clouds;
  final DateTime dt;
  final Sys sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  ResponseCurrentWeather({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  ResponseCurrentWeather copyWith({
    Coord? coord,
    List<Weather>? weather,
    String? base,
    Main? main,
    int? visibility,
    Wind? wind,
    Clouds? clouds,
    DateTime? dt,
    Sys? sys,
    int? timezone,
    int? id,
    String? name,
    int? cod,
  }) =>
      ResponseCurrentWeather(
        coord: coord ?? this.coord,
        weather: weather ?? this.weather,
        base: base ?? this.base,
        main: main ?? this.main,
        visibility: visibility ?? this.visibility,
        wind: wind ?? this.wind,
        clouds: clouds ?? this.clouds,
        dt: dt ?? this.dt,
        sys: sys ?? this.sys,
        timezone: timezone ?? this.timezone,
        id: id ?? this.id,
        name: name ?? this.name,
        cod: cod ?? this.cod,
      );

  Map<String, dynamic> toMap() => {
        'coord': coord.toMap(),
        'weather': weather.map((x) => x.toMap()).toList(),
        'base': base,
        'main': main.toMap(),
        'visibility': visibility,
        'wind': wind.toMap(),
        'clouds': clouds.toMap(),
        'dt': dt.millisecondsSinceEpoch,
        'sys': sys.toMap(),
        'timezone': timezone,
        'id': id,
        'name': name,
        'cod': cod,
      };

  factory ResponseCurrentWeather.fromMap(Map<String, dynamic> map) => ResponseCurrentWeather(
        coord: Coord.fromMap(map['coord']),
        weather: List<Weather>.from(map['weather']?.map((x) => Weather.fromMap(x))),
        base: map['base'] ?? '',
        main: Main.fromMap(map['main']),
        visibility: map['visibility']?.toInt() ?? 0,
        wind: Wind.fromMap(map['wind']),
        clouds: Clouds.fromMap(map['clouds']),
        dt: DateTime.fromMillisecondsSinceEpoch(map['dt']),
        sys: Sys.fromMap(map['sys']),
        timezone: map['timezone']?.toInt() ?? 0,
        id: map['id']?.toInt() ?? 0,
        name: map['name'] ?? '',
        cod: map['cod']?.toInt() ?? 0,
      );

  String toJson() => json.encode(toMap());

  factory ResponseCurrentWeather.fromJson(String source) => ResponseCurrentWeather.fromMap(json.decode(source));

  @override
  String toString() =>
      'ResponseCurrentWeather(coord: $coord, weather: $weather, base: $base, main: $main, visibility: $visibility, wind: $wind, clouds: $clouds, dt: $dt, sys: $sys, timezone: $timezone, id: $id, name: $name, cod: $cod)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ResponseCurrentWeather &&
        other.coord == coord &&
        listEquals(other.weather, weather) &&
        other.base == base &&
        other.main == main &&
        other.visibility == visibility &&
        other.wind == wind &&
        other.clouds == clouds &&
        other.dt == dt &&
        other.sys == sys &&
        other.timezone == timezone &&
        other.id == id &&
        other.name == name &&
        other.cod == cod;
  }

  @override
  int get hashCode =>
      coord.hashCode ^
      weather.hashCode ^
      base.hashCode ^
      main.hashCode ^
      visibility.hashCode ^
      wind.hashCode ^
      clouds.hashCode ^
      dt.hashCode ^
      sys.hashCode ^
      timezone.hashCode ^
      id.hashCode ^
      name.hashCode ^
      cod.hashCode;
}
