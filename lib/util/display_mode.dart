import 'package:flutter/foundation.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import '../services/logger_service.dart';

Future<void> setDisplayMode() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } catch (e) {
      LoggerService().e(e);
    }
  }
}
