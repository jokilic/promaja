import 'dart:convert';

import 'package:hive/hive.dart';

part 'notification_last_shown.g.dart';

@HiveType(typeId: 14)
class NotificationLastShown extends HiveObject {
  @HiveField(0)
  final DateTime morningNotificationLastShown;
  @HiveField(1)
  final DateTime eveningNotificationLastShown;

  NotificationLastShown({
    required this.morningNotificationLastShown,
    required this.eveningNotificationLastShown,
  });

  NotificationLastShown copyWith({
    DateTime? morningNotificationLastShown,
    DateTime? eveningNotificationLastShown,
  }) =>
      NotificationLastShown(
        morningNotificationLastShown: morningNotificationLastShown ?? this.morningNotificationLastShown,
        eveningNotificationLastShown: eveningNotificationLastShown ?? this.eveningNotificationLastShown,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'morningNotificationLastShown': morningNotificationLastShown.millisecondsSinceEpoch,
        'eveningNotificationLastShown': eveningNotificationLastShown.millisecondsSinceEpoch,
      };

  factory NotificationLastShown.fromMap(Map<String, dynamic> map) => NotificationLastShown(
        morningNotificationLastShown: DateTime.fromMillisecondsSinceEpoch(map['morningNotificationLastShown'] as int),
        eveningNotificationLastShown: DateTime.fromMillisecondsSinceEpoch(map['eveningNotificationLastShown'] as int),
      );

  String toJson() => json.encode(toMap());

  factory NotificationLastShown.fromJson(String source) => NotificationLastShown.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotificationLastShown(morningNotificationLastShown: $morningNotificationLastShown, eveningNotificationLastShown: $eveningNotificationLastShown)';

  @override
  bool operator ==(covariant NotificationLastShown other) {
    if (identical(this, other)) {
      return true;
    }

    return other.morningNotificationLastShown == morningNotificationLastShown && other.eveningNotificationLastShown == eveningNotificationLastShown;
  }

  @override
  int get hashCode => morningNotificationLastShown.hashCode ^ eveningNotificationLastShown.hashCode;
}
