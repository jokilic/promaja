import 'package:hive/hive.dart';

part 'morning_notification.g.dart';

@HiveType(typeId: 4)
enum MorningNotification {
  @HiveField(0)
  off,
  @HiveField(1)
  seven,
  @HiveField(2)
  eight,
  @HiveField(3)
  nine,
  @HiveField(4)
  ten,
}
