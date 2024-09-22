// ignore_for_file: unnecessary_lambdas

import 'package:flutter/foundation.dart';

import '../models/current_weather/response_current_weather.dart';
import '../models/error/response_error.dart';
import '../models/location/location.dart';
import '../models/weather/response_forecast_weather.dart';
import '../models/weather/response_history_weather.dart';

/// `current.json`
Future<ResponseCurrentWeather> computeCurrentWeather(data) async => compute(parseCurrentWeather, data);
ResponseCurrentWeather parseCurrentWeather(data) => ResponseCurrentWeather.fromMap(data);

/// `forecast.json`
Future<ResponseForecastWeather> computeForecastWeather(data) async => compute(parseForecastWeather, data);
ResponseForecastWeather parseForecastWeather(data) => ResponseForecastWeather.fromMap(data);

/// `history.json`
Future<ResponseHistoryWeather> computeHistoryWeather(data) async => compute(parseHistoryWeather, data);
ResponseHistoryWeather parseHistoryWeather(data) => ResponseHistoryWeather.fromMap(data);

/// `search.json`
Future<List<Location>> computeSearch(List<dynamic> data) async => compute(parseSearch, data);
List<Location> parseSearch(List<dynamic> data) => data.map((map) => Location.fromMap(map)).toList();

/// API error
Future<ResponseError> computeError(data) async => compute(parseError, data);
ResponseError parseError(data) => ResponseError.fromMap(data);
