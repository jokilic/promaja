import 'package:dio/dio.dart';

import '../constants/durations.dart';
import '../util/env.dart';

class DioService {
  ///
  /// VARIABLES
  ///

  late final dio = Dio(
    BaseOptions(
      baseUrl: Env.weatherApiBaseUrl,
      connectTimeout: PromajaDurations.apiTimeout,
      receiveTimeout: PromajaDurations.apiTimeout,
      sendTimeout: PromajaDurations.apiTimeout,
      validateStatus: (_) => true,
    ),
  );
}
