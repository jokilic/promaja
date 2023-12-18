import 'dart:convert';

import 'package:hive/hive.dart';

import '../../location/location.dart';
import 'evening_notification.dart';
import 'morning_notification.dart';

part 'notification_settings.g.dart';

@HiveType(typeId: 3)
class NotificationSettings extends HiveObject {
  @HiveField(0)
  final Location? location;
  @HiveField(1)
  final bool hourlyNotification;
  @HiveField(2)
  final MorningNotification morningNotification;
  @HiveField(3)
  final EveningNotification eveningNotification;

  NotificationSettings({
    required this.location,
    required this.hourlyNotification,
    required this.morningNotification,
    required this.eveningNotification,
  });

  NotificationSettings copyWith({
    Location? location,
    bool? hourlyNotification,
    MorningNotification? morningNotification,
    EveningNotification? eveningNotification,
  }) =>
      NotificationSettings(
        location: location ?? this.location,
        hourlyNotification: hourlyNotification ?? this.hourlyNotification,
        morningNotification: morningNotification ?? this.morningNotification,
        eveningNotification: eveningNotification ?? this.eveningNotification,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'location': location?.toMap(),
        'hourlyNotification': hourlyNotification,
        'morningNotification': morningNotification.name,
        'eveningNotification': eveningNotification.name,
      };

  factory NotificationSettings.fromMap(Map<String, dynamic> map) => NotificationSettings(
        location: map['location'] != null ? Location.fromMap(map['location'] as Map<String, dynamic>) : null,
        hourlyNotification: map['hourlyNotification'] as bool,
        morningNotification: MorningNotification.values.byName(map['morningNotification'] as String),
        eveningNotification: EveningNotification.values.byName(map['eveningNotification'] as String),
      );

  String toJson() => json.encode(toMap());

  factory NotificationSettings.fromJson(String source) => NotificationSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'NotificationSettings(location: $location, hourlyNotification: $hourlyNotification, morningNotification: $morningNotification, eveningNotification: $eveningNotification)';

  @override
  bool operator ==(covariant NotificationSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.location == location &&
        other.hourlyNotification == hourlyNotification &&
        other.morningNotification == morningNotification &&
        other.eveningNotification == eveningNotification;
  }

  @override
  int get hashCode => location.hashCode ^ hourlyNotification.hashCode ^ morningNotification.hashCode ^ eveningNotification.hashCode;
}