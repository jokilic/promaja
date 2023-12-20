import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

part 'precipitation_unit.g.dart';

@HiveType(typeId: 13)
enum PrecipitationUnit {
  @HiveField(0)
  millimeters,
  @HiveField(1)
  inches,
}

String localizePrecipitation(PrecipitationUnit precipitation) {
  switch (precipitation) {
    case PrecipitationUnit.millimeters:
      return 'unitMillimeters'.tr();
    case PrecipitationUnit.inches:
      return 'unitInches'.tr();
  }
}
