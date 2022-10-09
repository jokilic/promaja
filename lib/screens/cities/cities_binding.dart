import 'package:get/get.dart';

import 'cities_controller.dart';

class CitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(CitiesController.new);
  }
}
