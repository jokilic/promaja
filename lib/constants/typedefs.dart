import '../models/error/response_error.dart';
import '../models/weather/response_forecast_weather.dart';

typedef ForecastWeatherResult = ({
  ResponseForecastWeather? response,
  ResponseError? error,
  String? genericError,
});

typedef ForecastWeatherCacheEntry = ({ResponseForecastWeather response, DateTime fetchedAt});
