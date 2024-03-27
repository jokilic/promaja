import 'package:hive/hive.dart';

import 'initial_section.dart';

part 'appearance_settings.g.dart';

@HiveType(typeId: 18)
class AppearanceSettings extends HiveObject {
  @HiveField(0)
  final InitialSection initialSection;

  AppearanceSettings({
    required this.initialSection,
  });

  AppearanceSettings copyWith({
    InitialSection? initialSection,
  }) =>
      AppearanceSettings(
        initialSection: initialSection ?? this.initialSection,
      );

  @override
  String toString() => 'AppearanceSettings(initialSection: $initialSection)';

  @override
  bool operator ==(covariant AppearanceSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.initialSection == initialSection;
  }

  @override
  int get hashCode => initialSection.hashCode;
}
