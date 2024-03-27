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
      // TODO: Localize
      InitialSection.lastOpened => 'Last opened',
      InitialSection.current => 'Current',
      InitialSection.forecast => 'Forecast',
      InitialSection.list => 'List',
      InitialSection.settings => 'Settings',
    };
