import 'package:intl/intl.dart';

import '../models/promaja_log/promaja_log.dart';
import '../models/promaja_log/promaja_log_level.dart';
import '../services/hive_service.dart';
import '../services/logger_service.dart';

/// Logs & saves `PromajaLog` in [Hive]
void logPromajaEvent({
  required LoggerService logger,
  required HiveService hive,
  required String text,
  required PromajaLogLevel logLevel,
  required bool isError,
}) {
  final promajaLog = PromajaLog(
    text: text,
    time: DateTime.now(),
    logLevel: logLevel,
    isError: isError,
  );

  logger
    ..f('\n📄 PROMAJA LOG 📃', passedLogger: logger.logger2)
    ..f('--------------------', passedLogger: logger.logger2)
    ..f('Text -> ${promajaLog.text}', passedLogger: logger.logger2)
    ..f('Log level -> ${promajaLog.logLevel.name}${isError ? ' -> Error' : ''}', passedLogger: logger.logger2)
    ..f('Time -> ${DateFormat.Hms().format(promajaLog.time)}', passedLogger: logger.logger2)
    ..f('--------------------\n');

  hive.addPromajaLogToBox(promajaLog: promajaLog);
}
