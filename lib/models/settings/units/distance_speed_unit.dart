import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

part 'distance_speed_unit.g.dart';

@HiveType(typeId: 9)
enum DistanceSpeedUnit {
  @HiveField(0)
  kilometers,
  @HiveField(1)
  miles,
}

String localizeDistanceSpeed(DistanceSpeedUnit distanceSpeed) => switch (distanceSpeed) {
      DistanceSpeedUnit.kilometers => 'unitKilometers'.tr(),
      DistanceSpeedUnit.miles => 'unitMiles'.tr(),
    };
