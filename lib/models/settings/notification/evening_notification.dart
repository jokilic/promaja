import 'package:hive/hive.dart';

part 'evening_notification.g.dart';

@HiveType(typeId: 5)
enum EveningNotification {
  @HiveField(0)
  off,
  @HiveField(1)
  nineteen,
  @HiveField(2)
  twenty,
  @HiveField(3)
  twentyOne,
  @HiveField(4)
  twentyTwo,
}
