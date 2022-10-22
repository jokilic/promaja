import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../services/logger_service.dart';

///
/// PROVIDER
///

final settingsProvider = Provider(
  (ref) => SettingsController(
    loggerService: ref.watch(loggerProvider),
  ),
);

class SettingsController {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService loggerService;

  SettingsController({
    required this.loggerService,
  });
}
