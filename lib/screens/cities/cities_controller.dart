import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../services/logger_service.dart';

class CitiesController extends GetxController {
  ///
  /// DEPENDENCIES
  ///

  final logger = Get.find<LoggerService>();
  final api = Get.find<ApiService>();

  ///
  /// VARIABLES
  ///

  var someString = '';

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

  Future<void> fetchWeathers() async {
    final fetchWeatherList = [
      api.fetchCurrentWeather(lat: 55.7504461, lon: 37.6174943),
    ];

    final list = await Future.wait(fetchWeatherList);

    logger.wtf(list);
  }
}
