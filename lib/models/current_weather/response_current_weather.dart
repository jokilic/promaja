import '../location/location.dart';
import 'current_weather.dart';

class ResponseCurrentWeather {
  final Location location;
  final CurrentWeather current;

  ResponseCurrentWeather({
    required this.location,
    required this.current,
  });

  factory ResponseCurrentWeather.fromMap(Map<String, dynamic> map) => ResponseCurrentWeather(
        location: Location.fromMap(map['location'] as Map<String, dynamic>),
        current: CurrentWeather.fromMap(map['current'] as Map<String, dynamic>),
      );

  @override
  String toString() => 'ResponseCurrentWeather(location: $location, current: $current)';

  @override
  bool operator ==(covariant ResponseCurrentWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.location == location && other.current == current;
  }

  @override
  int get hashCode => location.hashCode ^ current.hashCode;
}
