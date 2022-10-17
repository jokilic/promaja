import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../services/logger_service.dart';

final onboardingProvider = Provider(
  (ref) => OnboardingController(
    loggerService: ref.watch(loggerProvider),
  ),
  name: 'OnboardingProvider',
);

class OnboardingController {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService loggerService;

  OnboardingController({
    required this.loggerService,
  });

  ///
  /// VARIABLES
  ///

  var someString = '';

  ///
  /// METHODS
  ///

  void someMethod() {}
}
