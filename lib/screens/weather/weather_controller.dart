import 'package:get/get.dart';

import '../../constants/endpoints.dart';
import '../../constants/enums.dart';
import '../../models/current_weather/response_current_weather.dart';
import '../../services/dio_service.dart';
import '../../services/logger_service.dart';
import '../../util/isolates.dart';
import '../../util/snackbars.dart';

class WeatherController extends GetxController {
  ///
  /// DEPENDENCIES
  ///

  final logger = Get.find<LoggerService>();
  final dioService = Get.find<DioService>();

  ///
  /// VARIABLES
  ///

  late final langQueryParameter = getLangQueryParameter();

  ///
  /// INIT
  ///

  @override
  void onInit() {
    super.onInit();
  }

  ///
  /// METHODS
  ///

  Future<void> fetchCurrentWeather() async {
    const endpoint = '${PromajaEndpoints.baseUrl}${PromajaEndpoints.currentWeather}';

    final queryParameters = {
      'lat': 45.8150,
      'lon': 15.9819,
      'appid': PromajaEndpoints.apiKey,
      'units': 'metric',
      if (langQueryParameter != null) 'lang': langQueryParameter,
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

  ///
  /// Checks device language code against `OpenWeatherMap` language codes
  /// If language code is found, it's used as a query parameter when fetching weather
  ///
  String? getLangQueryParameter() {
    late String? lang;

    try {
      if (Get.deviceLocale != null) {
        final languageCode = Get.deviceLocale!.languageCode;
        lang = ResponseLanguage.values.byName(languageCode).name;
      }
    } catch (e) {
      lang = null;
    }

    return lang;
  }
}
