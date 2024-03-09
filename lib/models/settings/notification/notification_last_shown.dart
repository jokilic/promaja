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
