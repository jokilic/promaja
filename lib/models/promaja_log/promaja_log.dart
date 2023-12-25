import 'dart:convert';

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
  final PromajaLogLevel logLevel;

  PromajaLog({
    required this.text,
    required this.time,
    required this.logLevel,
  });

  PromajaLog copyWith({
    String? text,
    DateTime? time,
    PromajaLogLevel? logLevel,
  }) =>
      PromajaLog(
        text: text ?? this.text,
        time: time ?? this.time,
        logLevel: logLevel ?? this.logLevel,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'text': text,
        'time': time.millisecondsSinceEpoch,
        'logLevel': logLevel.name,
      };

  factory PromajaLog.fromMap(Map<String, dynamic> map) => PromajaLog(
        text: map['text'] as String,
        time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
        logLevel: PromajaLogLevel.values.byName(map['logLevel'] as String),
      );

  String toJson() => json.encode(toMap());

  factory PromajaLog.fromJson(String source) => PromajaLog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PromajaLog(text: $text, time: $time, logLevel: $logLevel)';

  @override
  bool operator ==(covariant PromajaLog other) {
    if (identical(this, other)) {
      return true;
    }

    return other.text == text && other.time == time && other.logLevel == logLevel;
  }

  @override
  int get hashCode => text.hashCode ^ time.hashCode ^ logLevel.hashCode;
}
