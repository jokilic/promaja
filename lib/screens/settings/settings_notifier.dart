import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/settings/promaja_settings.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

final settingsProvider = StateNotifierProvider.autoDispose<SettingsNotifier, PromajaSettings>(
  (ref) => SettingsNotifier(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'SettingsProvider',
);

class SettingsNotifier extends StateNotifier<PromajaSettings> {
  final LoggerService logger;
  final HiveService hive;

  SettingsNotifier({
    required this.logger,
    required this.hive,
  }) : super(hive.getPromajaSettingsFromBox());

  ///
  /// METHODS
  ///

  /// Updates settings with new [PromajaSettings]
  Future<void> updateSettings(PromajaSettings newSettings) async {
    state = newSettings;
    await hive.addPromajaSettingsToBox(promajaSettings: newSettings);
  }
}
