import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';

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
  list,
  @HiveField(4)
  settings,
}

String localizeInitialSection(InitialSection initialSection) => switch (initialSection) {
      InitialSection.lastOpened => 'appearanceInitialSectionLastOpened'.tr(),
      InitialSection.current => 'appearanceInitialSectionCurrent'.tr(),
      InitialSection.forecast => 'appearanceInitialSectionForecast'.tr(),
      InitialSection.list => 'appearanceInitialSectionList'.tr(),
      InitialSection.settings => 'appearanceInitialSectionSettings'.tr(),
    };
