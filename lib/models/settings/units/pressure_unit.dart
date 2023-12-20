import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

part 'pressure_unit.g.dart';

@HiveType(typeId: 10)
enum PressureUnit {
  @HiveField(0)
  hectopascal,
  @HiveField(1)
  inchesOfMercury,
}

String localizePressure(PressureUnit pressure) {
  switch (pressure) {
    case PressureUnit.hectopascal:
      return 'unitHectopascal'.tr();
    case PressureUnit.inchesOfMercury:
      return 'unitInchesOfMercury'.tr();
  }
}
