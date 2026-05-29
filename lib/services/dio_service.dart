import 'package:dio/dio.dart';

import '../util/env.dart';

class DioService {
  ///
  /// VARIABLES
  ///

  late final dio = Dio(
    BaseOptions(
      baseUrl: Env.weatherApiBaseUrl,
      validateStatus: (_) => true,
    ),
  );
}
