import 'dart:convert';

class Wind {
  final double speed;
  final int deg;

  Wind({
    required this.speed,
    required this.deg,
  });

  Wind copyWith({
    double? speed,
    int? deg,
  }) =>
      Wind(
        speed: speed ?? this.speed,
        deg: deg ?? this.deg,
      );

  Map<String, dynamic> toMap() => {
        'speed': speed,
        'deg': deg,
      };

  factory Wind.fromMap(Map<String, dynamic> map) => Wind(
        speed: map['speed']?.toDouble() ?? 0.0,
        deg: map['deg']?.toInt() ?? 0,
      );

  String toJson() => json.encode(toMap());

  factory Wind.fromJson(String source) => Wind.fromMap(json.decode(source));

  @override
  String toString() => 'Wind(speed: $speed, deg: $deg)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Wind && other.speed == speed && other.deg == deg;
  }

  @override
  int get hashCode => speed.hashCode ^ deg.hashCode;
}
