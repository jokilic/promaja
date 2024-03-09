import 'package:hive/hive.dart';

import '../../location/location.dart';
import 'weather_type.dart';

part 'widget_settings.g.dart';

@HiveType(typeId: 6)
class WidgetSettings extends HiveObject {
  @HiveField(0)
  final Location? location;
  @HiveField(1)
  final WeatherType weatherType;

  WidgetSettings({
    required this.location,
    required this.weatherType,
  });

  WidgetSettings copyWith({
    Location? location,
    WeatherType? weatherType,
  }) =>
      WidgetSettings(
        location: location ?? this.location,
        weatherType: weatherType ?? this.weatherType,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'location': location?.toMap(),
        'weatherType': weatherType.name,
      };

  factory WidgetSettings.fromMap(Map<String, dynamic> map) => WidgetSettings(
        location: map['location'] != null ? Location.fromMap(map['location'] as Map<String, dynamic>) : null,
        weatherType: WeatherType.values.byName(map['weatherType'] as String),
      );

  @override
  String toString() => 'WidgetSettings(location: $location, weatherType: $weatherType)';

  @override
  bool operator ==(covariant WidgetSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.location == location && other.weatherType == weatherType;
  }

  @override
  int get hashCode => location.hashCode ^ weatherType.hashCode;
}
