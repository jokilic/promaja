import 'dart:convert';

import '../location/location.dart';
import '../settings/notification/notification_type.dart';

class NotificationPayload {
  final Location? location;
  final NotificationType notificationType;

  NotificationPayload({
    required this.location,
    required this.notificationType,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'location': location?.toMap(),
        'notificationType': notificationType.name,
      };

  factory NotificationPayload.fromMap(Map<String, dynamic> map) => NotificationPayload(
        location: map['location'] != null ? Location.fromMap(map['location'] as Map<String, dynamic>) : null,
        notificationType: NotificationType.values.byName(map['notificationType'] as String),
      );

  String toJson() => json.encode(toMap());

  factory NotificationPayload.fromJson(String source) => NotificationPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotificationPayload(location: $location, notificationType: $notificationType)';

  @override
  bool operator ==(covariant NotificationPayload other) {
    if (identical(this, other)) {
      return true;
    }

    return other.location == location && other.notificationType == notificationType;
  }

  @override
  int get hashCode => location.hashCode ^ notificationType.hashCode;
}
