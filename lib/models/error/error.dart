class APIError {
  final int code;
  final String message;

  APIError({
    required this.code,
    required this.message,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'code': code,
        'message': message,
      };

  factory APIError.fromMap(Map<String, dynamic> map) => APIError(
        code: map['code'] as int,
        message: map['message'] as String,
      );

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
