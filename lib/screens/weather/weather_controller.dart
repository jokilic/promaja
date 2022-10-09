import 'package:get/get.dart';

import '../../constants/endpoints.dart';
import '../../models/current_weather/response_current_weather.dart';
import '../../services/dio_service.dart';
import '../../services/logger_service.dart';
import '../../util/isolates.dart';
import '../../util/snackbars.dart';

class WeatherController extends GetxController {
  final logger = Get.find<LoggerService>();
  final dioService = Get.find<DioService>();

  /// ------------------------
  /// REACTIVE VARIABLES
  /// ------------------------

  final _someReactiveString = ''.obs;
  String get someReactiveString => _someReactiveString.value;
  set someReactiveString(String value) => _someReactiveString.value = value;

  /// ------------------------
  /// VARIABLES
  /// ------------------------

  var someString = 'Promajaa';

  /// ------------------------
  /// INIT
  /// ------------------------

  /// ------------------------
  /// METHODS
  /// ------------------------

  Future<void> fetchCurrentWeather() async {
    const endpoint = '${PromajaEndpoints.baseUrl}${PromajaEndpoints.currentWeather}';

    final queryParameters = {
      'lat': 45.8150,
      'lon': 15.9819,
      'appid': PromajaEndpoints.apiKey,
      'units': 'metric',
      'lang': 'hr',
    };

    final parsedWeather = await dioService.request<ResponseCurrentWeather>(
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
