import 'package:easy_localization/easy_localization.dart';
import 'package:hive_ce/hive.dart';

part 'initial_section.g.dart';

@HiveType(typeId: 17)
enum InitialSection {
  @HiveField(0)
  lastOpened,
  @HiveField(1)
  current,
  @HiveField(2)
  forecast,
  @HiveField(3)
  map,
  @HiveField(4)
  list,
  @HiveField(5)
  settings,
}

String localizeInitialSection(InitialSection initialSection) => switch (initialSection) {
  InitialSection.lastOpened => 'appearanceInitialSectionLastOpened'.tr(),
  InitialSection.current => 'appearanceInitialSectionCurrent'.tr(),
  InitialSection.forecast => 'appearanceInitialSectionForecast'.tr(),
  InitialSection.map => 'appearanceInitialSectionMap'.tr(),
  InitialSection.list => 'appearanceInitialSectionList'.tr(),
  InitialSection.settings => 'appearanceInitialSectionSettings'.tr(),
};
