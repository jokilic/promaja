import 'package:easy_localization/easy_localization.dart';
import 'package:hive_ce/hive.dart';

part 'pressure_unit.g.dart';

@HiveType(typeId: 10)
enum PressureUnit {
  @HiveField(0)
  hectopascal,
  @HiveField(1)
  inchesOfMercury,
}

String localizePressure(PressureUnit pressure) => switch (pressure) {
      PressureUnit.hectopascal => 'unitHectopascal'.tr(),
      PressureUnit.inchesOfMercury => 'unitInchesOfMercury'.tr(),
    };
