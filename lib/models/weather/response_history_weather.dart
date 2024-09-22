import '../location/location.dart';
import 'forecast_weather.dart';

class ResponseHistoryWeather {
  final Location location;
  final ForecastWeather forecast;

  ResponseHistoryWeather({
    required this.location,
    required this.forecast,
  });

  factory ResponseHistoryWeather.fromMap(Map<String, dynamic> map) => ResponseHistoryWeather(
        location: Location.fromMap(map['location'] as Map<String, dynamic>),
        forecast: ForecastWeather.fromMap(map['forecast'] as Map<String, dynamic>),
      );

  @override
  String toString() => 'ResponseHistoryWeather(location: $location, forecast: $forecast)';

  @override
  bool operator ==(covariant ResponseHistoryWeather other) {
    if (identical(this, other)) {
      return true;
    }

    return other.location == location && other.forecast == forecast;
  }

  @override
  int get hashCode => location.hashCode ^ forecast.hashCode;
}
