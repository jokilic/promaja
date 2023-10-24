import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final LoggerService loggerService;

  DioService(this.loggerService) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://api.weatherapi.com/v1',
      ),
    )..interceptors.add(
        DioLoggerInterceptor(loggerService),
      );
  }

  ///
  /// VARIABLES
  ///

  late final Dio dio;
}
