import 'dart:convert';

class Sys {
  final int type;
  final int id;
  final String country;
  final int sunrise;
  final int sunset;

  Sys({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  Sys copyWith({
    int? type,
    int? id,
    String? country,
    int? sunrise,
    int? sunset,
  }) =>
      Sys(
        type: type ?? this.type,
        id: id ?? this.id,
        country: country ?? this.country,
        sunrise: sunrise ?? this.sunrise,
        sunset: sunset ?? this.sunset,
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'id': id,
        'country': country,
        'sunrise': sunrise,
        'sunset': sunset,
      };

  factory Sys.fromMap(Map<String, dynamic> map) => Sys(
        type: map['type']?.toInt() ?? 0,
        id: map['id']?.toInt() ?? 0,
        country: map['country'] ?? '',
        sunrise: map['sunrise']?.toInt() ?? 0,
        sunset: map['sunset']?.toInt() ?? 0,
      );

  String toJson() => json.encode(toMap());

  factory Sys.fromJson(String source) => Sys.fromMap(json.decode(source));

  @override
  String toString() => 'Sys(type: $type, id: $id, country: $country, sunrise: $sunrise, sunset: $sunset)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Sys && other.type == type && other.id == id && other.country == country && other.sunrise == sunrise && other.sunset == sunset;
  }

  @override
  int get hashCode => type.hashCode ^ id.hashCode ^ country.hashCode ^ sunrise.hashCode ^ sunset.hashCode;
}
