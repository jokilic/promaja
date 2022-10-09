///
/// This is a class where all endpoints are stored
/// You can then reference them in code with `PromajaEndpoints.someEndpoint`
///

class PromajaEndpoints {
  static const baseUrl = 'https://api.openweathermap.org/';
  static const apiKey = 'e80b3708958fcb0d64691dfe8cbba31e';

  /// https://openweathermap.org/current
  static const currentWeather = 'data/2.5/weather';

  /// https://openweathermap.org/forecast5
  static const forecastWeather = 'data/2.5/forecast';

  /// https://openweathermap.org/api/geocoding-api
  static const geocoding = '/geo/1.0/direct';
  static const reverseGeocoding = '/geo/1.0/reverse';
}
