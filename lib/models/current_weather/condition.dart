import 'dart:convert';

class Condition {
  final int code;

  Condition({
    required this.code,
  });

  Condition copyWith({
    int? code,
  }) =>
      Condition(
        code: code ?? this.code,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'code': code,
      };

  factory Condition.fromMap(Map<String, dynamic> map) => Condition(
        code: map['code'] as int,
      );

  String toJson() => json.encode(toMap());

  factory Condition.fromJson(String source) => Condition.fromMap(json.decode(source) as Map<String, dynamic>);

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
