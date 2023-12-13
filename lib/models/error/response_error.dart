import 'dart:convert';

import 'error.dart';

class ResponseError {
  final APIError error;

  ResponseError({
    required this.error,
  });

  ResponseError copyWith({
    APIError? error,
  }) =>
      ResponseError(
        error: error ?? this.error,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'error': error.toMap(),
      };

  factory ResponseError.fromMap(Map<String, dynamic> map) => ResponseError(
        error: APIError.fromMap(map['error'] as Map<String, dynamic>),
      );

  String toJson() => json.encode(toMap());

  factory ResponseError.fromJson(String source) => ResponseError.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ResponseError(error: $error)';

  @override
  bool operator ==(covariant ResponseError other) {
    if (identical(this, other)) {
      return true;
    }

    return other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
