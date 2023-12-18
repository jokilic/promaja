import 'package:hive/hive.dart';

part 'pressure_unit.g.dart';

@HiveType(typeId: 10)
enum PressureUnit {
  @HiveField(0)
  hectopascal,
  @HiveField(1)
  inchesOfMercury,
}
