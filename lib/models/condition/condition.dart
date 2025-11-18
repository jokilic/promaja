class Condition {
  final int code;

  Condition({
    required this.code,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'code': code,
  };

  factory Condition.fromMap(Map<String, dynamic> map) => Condition(
    code: map['code'] as int,
  );

  @override
  String toString() => 'Condition(code: $code)';

  @override
  bool operator ==(covariant Condition other) {
    if (identical(this, other)) {
      return true;
    }

    return other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
