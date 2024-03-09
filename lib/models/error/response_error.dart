import 'error.dart';

class ResponseError {
  final APIError error;

  ResponseError({
    required this.error,
  });

  factory ResponseError.fromMap(Map<String, dynamic> map) => ResponseError(
        error: APIError.fromMap(map['error'] as Map<String, dynamic>),
      );

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
