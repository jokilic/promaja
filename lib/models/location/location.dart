import 'package:hive_ce/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 1)
class Location extends HiveObject {
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String region;
  @HiveField(3)
  final String country;
  @HiveField(4)
  final double lat;
  @HiveField(5)
  final double lon;
  @HiveField(6)
  final bool? isPhoneLocation;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    this.isPhoneLocation = false,
  });

  Location copyWith({
    String? name,
    String? region,
    String? country,
    double? lat,
    double? lon,
    bool? isPhoneLocation,
  }) =>
      Location(
        name: name ?? this.name,
        region: region ?? this.region,
        country: country ?? this.country,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        isPhoneLocation: isPhoneLocation ?? this.isPhoneLocation,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'region': region,
        'country': country,
        'lat': lat,
        'lon': lon,
      };

  factory Location.fromMap(Map<String, dynamic> map) => Location(
        name: map['name'] as String,
        region: map['region'] as String,
        country: map['country'] as String,
        lat: map['lat'] as double,
        lon: map['lon'] as double,
      );

  @override
  String toString() => 'Location(name: $name, region: $region, country: $country, lat: $lat, lon: $lon, isPhoneLocation: $isPhoneLocation)';

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) {
      return true;
    }

    return other.name == name && other.region == region && other.country == country && other.lat == lat && other.lon == lon && other.isPhoneLocation == isPhoneLocation;
  }

  @override
  int get hashCode => name.hashCode ^ region.hashCode ^ country.hashCode ^ lat.hashCode ^ lon.hashCode ^ isPhoneLocation.hashCode;
}
