import 'package:easy_localization/easy_localization.dart';
import 'package:hive_ce/hive.dart';

part 'precipitation_unit.g.dart';

@HiveType(typeId: 13)
enum PrecipitationUnit {
  @HiveField(0)
  millimeters,
  @HiveField(1)
  inches,
}

String localizePrecipitation(PrecipitationUnit precipitation) => switch (precipitation) {
      PrecipitationUnit.millimeters => 'unitMillimeters'.tr(),
      PrecipitationUnit.inches => 'unitInches'.tr(),
    };
