import 'package:hive/hive.dart';

import 'promaja_log_level.dart';

part 'promaja_log.g.dart';

@HiveType(typeId: 15)
class PromajaLog extends HiveObject {
  @HiveField(0)
  final String text;
  @HiveField(1)
  final DateTime time;
  @HiveField(2)
  final PromajaLogGroup logGroup;
  @HiveField(3)
  final bool isError;

  PromajaLog({
    required this.text,
    required this.time,
    required this.logGroup,
    required this.isError,
  });

  @override
  String toString() => 'PromajaLog(text: $text, time: $time, logGroup: $logGroup, isError: $isError)';

  @override
  bool operator ==(covariant PromajaLog other) {
    if (identical(this, other)) {
      return true;
    }

    return other.text == text && other.time == time && other.logGroup == logGroup && other.isError == isError;
  }

  @override
  int get hashCode => text.hashCode ^ time.hashCode ^ logGroup.hashCode ^ isError.hashCode;
}
