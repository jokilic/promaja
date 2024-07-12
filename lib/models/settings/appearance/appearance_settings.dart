import 'package:hive_ce/hive.dart';

import 'initial_section.dart';

part 'appearance_settings.g.dart';

@HiveType(typeId: 18)
class AppearanceSettings extends HiveObject {
  @HiveField(0)
  final InitialSection initialSection;
  @HiveField(1)
  final bool weatherSummaryFirst;

  AppearanceSettings({
    required this.initialSection,
    required this.weatherSummaryFirst,
  });

  AppearanceSettings copyWith({
    InitialSection? initialSection,
    bool? weatherSummaryFirst,
  }) =>
      AppearanceSettings(
        initialSection: initialSection ?? this.initialSection,
        weatherSummaryFirst: weatherSummaryFirst ?? this.weatherSummaryFirst,
      );

  @override
  String toString() => 'AppearanceSettings(initialSection: $initialSection, weatherSummaryFirst: $weatherSummaryFirst)';

  @override
  bool operator ==(covariant AppearanceSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.initialSection == initialSection && other.weatherSummaryFirst == weatherSummaryFirst;
  }

  @override
  int get hashCode => initialSection.hashCode ^ weatherSummaryFirst.hashCode;
}
