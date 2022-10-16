import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../services/logger_service.dart';

final weatherProvider = Provider(
  (ref) => WeatherController(
    logger: ref.watch(loggerProvider),
  ),
);

class WeatherController {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  WeatherController({
    required this.logger,
  });

  ///
  /// METHODS
  ///

}
