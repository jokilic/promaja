enum WeatherMapOverlayType {
  temperature,
  precipitation,
  pressure,
  windSpeed,
}

String getTileSegment(WeatherMapOverlayType overlayType) => switch (overlayType) {
  WeatherMapOverlayType.temperature => 'tmp2m',
  WeatherMapOverlayType.precipitation => 'precip',
  WeatherMapOverlayType.pressure => 'pressure',
  WeatherMapOverlayType.windSpeed => 'wind',
};

// TODO: Localize
String getTileLabel(WeatherMapOverlayType overlayType) => switch (overlayType) {
  WeatherMapOverlayType.temperature => 'Temperature',
  WeatherMapOverlayType.precipitation => 'Precipitation',
  WeatherMapOverlayType.pressure => 'Pressure',
  WeatherMapOverlayType.windSpeed => 'Wind',
};
