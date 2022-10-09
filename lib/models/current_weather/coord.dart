import 'dart:convert';

class Coord {
  final double lat;
  final double lon;

  Coord({
    required this.lat,
    required this.lon,
  });

  Coord copyWith({
    double? lat,
    double? lon,
  }) =>
      Coord(
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
      );

  Map<String, dynamic> toMap() => {
        'lat': lat,
        'lon': lon,
      };

  factory Coord.fromMap(Map<String, dynamic> map) => Coord(
        lat: map['lat']?.toDouble() ?? 0.0,
        lon: map['lon']?.toDouble() ?? 0.0,
      );

  String toJson() => json.encode(toMap());

  factory Coord.fromJson(String source) => Coord.fromMap(json.decode(source));

  @override
  String toString() => 'Coord(lat: $lat, lon: $lon)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Coord && other.lat == lat && other.lon == lon;
  }

  @override
  int get hashCode => lat.hashCode ^ lon.hashCode;
}
