import 'package:hive_ce/hive.dart';

import 'initial_section.dart';
import 'weather_card_layout.dart';

part 'appearance_settings.g.dart';

@HiveType(typeId: 18)
class AppearanceSettings extends HiveObject {
  @HiveField(0)
  final InitialSection initialSection;
  @HiveField(1)
  final bool weatherSummaryFirst;
  @HiveField(2, defaultValue: WeatherCardLayout.stacked)
  final WeatherCardLayout weatherCardLayout;

  AppearanceSettings({
    required this.initialSection,
    required this.weatherSummaryFirst,
    required this.weatherCardLayout,
  });

  AppearanceSettings copyWith({
    InitialSection? initialSection,
    bool? weatherSummaryFirst,
    WeatherCardLayout? weatherCardLayout,
  }) => AppearanceSettings(
    initialSection: initialSection ?? this.initialSection,
    weatherSummaryFirst: weatherSummaryFirst ?? this.weatherSummaryFirst,
    weatherCardLayout: weatherCardLayout ?? this.weatherCardLayout,
  );

  @override
  String toString() => 'AppearanceSettings(initialSection: $initialSection, weatherSummaryFirst: $weatherSummaryFirst, weatherCardLayout: $weatherCardLayout)';

  @override
  bool operator ==(covariant AppearanceSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.initialSection == initialSection && other.weatherSummaryFirst == weatherSummaryFirst && other.weatherCardLayout == weatherCardLayout;
  }

  @override
  int get hashCode => initialSection.hashCode ^ weatherSummaryFirst.hashCode ^ weatherCardLayout.hashCode;
}
