import '../models/current_weather/response_current_weather.dart';
import '../models/error/response_error.dart';
import '../models/location/location.dart';
import '../models/weather/response_forecast_weather.dart';

///
/// CURRENT
///

typedef CurrentWeatherResult = ({
  ResponseCurrentWeather? response,
  ResponseError? error,
  String? genericError,
});

typedef CurrentWeatherCacheEntry = ({
  ResponseCurrentWeather response,
  DateTime fetchedAt,
});

///
/// FORECAST
///

typedef ForecastWeatherResult = ({
  ResponseForecastWeather? response,
  ResponseError? error,
  String? genericError,
});

typedef ForecastWeatherCacheEntry = ({
  ResponseForecastWeather response,
  DateTime fetchedAt,
});

///
/// SEARCH
///

typedef SearchResult = ({
  List<Location>? response,
  ResponseError? error,
  String? genericError,
});
