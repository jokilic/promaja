import 'package:hive_ce/hive.dart';

import '../../location/location.dart';

part 'notification_settings.g.dart';

@HiveType(typeId: 3)
class NotificationSettings extends HiveObject {
  @HiveField(0)
  final Location? location;
  @HiveField(1)
  final bool hourlyNotification;
  @HiveField(2)
  final bool morningNotification;
  @HiveField(3)
  final bool eveningNotification;

  NotificationSettings({
    required this.location,
    required this.hourlyNotification,
    required this.morningNotification,
    required this.eveningNotification,
  });

  NotificationSettings copyWith({
    Location? location,
    bool? hourlyNotification,
    bool? morningNotification,
    bool? eveningNotification,
  }) =>
      NotificationSettings(
        location: location ?? this.location,
        hourlyNotification: hourlyNotification ?? this.hourlyNotification,
        morningNotification: morningNotification ?? this.morningNotification,
        eveningNotification: eveningNotification ?? this.eveningNotification,
      );

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
