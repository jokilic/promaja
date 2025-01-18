import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/env.dart';
import 'logger_service.dart';

///
/// Service which holds an instance of `Dio`
/// Used for networking
/// Contains methods that ease our networking logic
///

final dioProvider = Provider<DioService>(
  (ref) => DioService(ref.watch(loggerProvider)),
  name: 'DioProvider',
);

class DioService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService loggerService;

  DioService(this.loggerService)

  ///
  /// INIT
  ///

  {
    dio = Dio(
      BaseOptions(
        baseUrl: kIsWeb ? Env.cloudflareWorkerUrl : Env.weatherApiBaseUrl,
        validateStatus: (_) => true,
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
