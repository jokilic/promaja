import '../current_weather/current_weather.dart';
import '../location/location.dart';
import 'forecast_weather.dart';

class ResponseForecastWeather {
  final Location location;
  final CurrentWeather current;
  final ForecastWeather forecast;

  ResponseForecastWeather({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory ResponseForecastWeather.fromMap(Map<String, dynamic> map) => ResponseForecastWeather(
        location: Location.fromMap(map['location'] as Map<String, dynamic>),
        current: CurrentWeather.fromMap(map['current'] as Map<String, dynamic>),
        forecast: ForecastWeather.fromMap(map['forecast'] as Map<String, dynamic>),
      );

  @override
  String toString() => 'ResponseForecastWeather(location: $location, current: $current, forecast: $forecast)';

  @override
  bool operator ==(covariant ResponseForecastWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.location == location && other.current == current && other.forecast == forecast;
  }

  @override
  int get hashCode => location.hashCode ^ current.hashCode ^ forecast.hashCode;
}
