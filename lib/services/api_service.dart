import 'package:get/get.dart';

import '../constants/endpoints.dart';
import '../models/current_weather/response_current_weather.dart';
import '../util/isolates.dart';
import '../util/language.dart';
import '../util/snackbars.dart';
import 'dio_service.dart';

class ApiService extends GetxService {
  ///
  /// DEPENDENCIES
  ///

  final dio = Get.find<DioService>();

  ///
  /// VARIABLES
  ///

  late final langQueryParameter = getLangQueryParameter();

  ///
  /// METHODS
  ///

  ///
  /// Calls the `Current Weather Data` endpoint and returns parsed model
  /// https://openweathermap.org/current
  ///
  Future<ResponseCurrentWeather?> fetchCurrentWeather({required double lat, required double lon}) async {
    const endpoint = '${PromajaEndpoints.baseUrl}${PromajaEndpoints.currentWeather}';

    final queryParameters = {
      'lat': lat,
      'lon': lon,
      'appid': PromajaEndpoints.apiKey,
      'units': 'metric',
      if (langQueryParameter != null) 'lang': langQueryParameter,
    };

    return dio.request<ResponseCurrentWeather>(
      endpoint: endpoint,
      parameters: queryParameters,
      httpMethod: HttpMethod.get,
      onSuccess: computeCurrentWeather,
      onError: (error) => PromajaSnackbars.showErrorSnackbar(
        message: 'Parsing current weather failed',
      ),
    );
  }
}
