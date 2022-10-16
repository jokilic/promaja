import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'logger_service.dart';

///
/// Service which stores information regarding the device
/// which is running the app
///

class DeviceInfoService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;

  DeviceInfoService({
    required this.logger,
  }) {
    initProperInfo();
  }

  ///
  /// VARIABLES
  ///

  late final deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iOSInfo;
  WebBrowserInfo? webBrowserInfo;

  ///
  /// METHODS
  ///

  /// Logs proper info depending on the platform running the app
  Future<void> initProperInfo() async {
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
      logger
        ..v('DEVICE INFO')
        ..v('--------------------')
        ..v('Platform: Android')
        ..v('--------------------\n');
    }
    if (Platform.isIOS) {
      iOSInfo = await deviceInfo.iosInfo;
      logger
        ..v('DEVICE INFO')
        ..v('--------------------')
        ..v('Platform: iOS')
        ..v('--------------------\n');
    }
    if (kIsWeb) {
      webBrowserInfo = await deviceInfo.webBrowserInfo;
      logger
        ..v('DEVICE INFO')
        ..v('--------------------')
        ..v('Platform: Web')
        ..v('--------------------\n');
    }
  }
}
