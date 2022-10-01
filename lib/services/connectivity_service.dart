import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import 'logger_service.dart';

///
/// Service which uses the [Connectivity] plugin to
/// trigger a method when internet connectivity changes
///

class ConnectivityService extends GetxService {
  ///
  /// DEPENDENCIES
  ///

  final logger = Get.find<LoggerService>();

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
