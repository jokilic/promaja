import 'package:hive/hive.dart';

part 'promaja_log_level.g.dart';

@HiveType(typeId: 16)
enum PromajaLogLevel {
  @HiveField(0)
  info,
  @HiveField(1)
  error,
}
