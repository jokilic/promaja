import 'dart:convert';

class APIError {
  final int code;
  final String message;

  APIError({
    required this.code,
    required this.message,
  });

  APIError copyWith({
    int? code,
    String? message,
  }) =>
      APIError(
        code: code ?? this.code,
        message: message ?? this.message,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'code': code,
        'message': message,
      };

  factory APIError.fromMap(Map<String, dynamic> map) => APIError(
        code: map['code'] as int,
        message: map['message'] as String,
      );

  String toJson() => json.encode(toMap());

  factory APIError.fromJson(String source) => APIError.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'APIError(code: $code, message: $message)';

  @override
  bool operator ==(covariant APIError other) {
    if (identical(this, other)) {
      return true;
    }

    return other.code == code && other.message == message;
  }

  @override
  int get hashCode => code.hashCode ^ message.hashCode;
}
