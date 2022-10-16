import 'package:connectivity_plus/connectivity_plus.dart';

import 'logger_service.dart';

///
/// Service which uses the [Connectivity] plugin to
/// trigger a method when internet connectivity changes
///

class ConnectivityService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  ConnectivityService({
    required this.logger,
  });

  ///
  /// VARIABLES
  ///

  /// Triggers a callback each time internet connection changes state
  late final connectivityListener = Connectivity().onConnectivityChanged.listen(
        (result) => logger
          ..v('CONNECTIVITY')
          ..v('--------------------')
          ..v('New connectivity status')
          ..v('$result')
          ..v('--------------------\n'),
      );
}
