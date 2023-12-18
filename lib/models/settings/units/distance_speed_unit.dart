import 'package:hive/hive.dart';

part 'distance_speed_unit.g.dart';

@HiveType(typeId: 9)
enum DistanceSpeedUnit {
  @HiveField(0)
  kilometers,
  @HiveField(1)
  miles,
}
