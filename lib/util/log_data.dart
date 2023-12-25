import '../models/promaja_log/promaja_log.dart';
import '../models/promaja_log/promaja_log_level.dart';
import '../services/hive_service.dart';
import '../services/logger_service.dart';

/// Saves `PromajaLog` with `info` level in [Hive]
void logInfo({
  required LoggerService logger,
  required HiveService hive,
  required String text,
}) {
  logger.t(text);

  final promajaLog = PromajaLog(
    text: text,
    time: DateTime.now(),
    logLevel: PromajaLogLevel.info,
  );

  hive.addPromajaLogToBox(promajaLog: promajaLog);
}

/// Saves `PromajaLog` with `error` level in [Hive]
void logError({
  required LoggerService logger,
  required HiveService hive,
  required String text,
}) {
  logger.e(text);

  final promajaLog = PromajaLog(
    text: text,
    time: DateTime.now(),
    logLevel: PromajaLogLevel.error,
  );

  hive.addPromajaLogToBox(promajaLog: promajaLog);
}
