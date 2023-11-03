import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nirikshak/nirikshak.dart';

import 'logger_service.dart';

///
/// Service which holds an instance of `Dio`
/// Used for networking
/// Contains methods that ease our networking logic
///

final dioProvider = Provider<DioService>(
  (_) => throw UnimplementedError(),
  name: 'DioProvider',
);

class DioService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService loggerService;
  final Nirikshak nirikshak;

  DioService({
    required this.loggerService,
    required this.nirikshak,
  })

  ///
  /// INIT
  ///

  {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://api.weatherapi.com/v1',
      ),
    )
      ..interceptors.add(
        DioLoggerInterceptor(loggerService),
      )
      ..interceptors.add(
        nirikshak.getDioInterceptor(),
      );
  }

  ///
  /// VARIABLES
  ///

  late final Dio dio;

  ///
  /// METHODS
  ///

  void showNirikshak(BuildContext context) => nirikshak.showNirikshak(context);
}
