import 'package:get/get.dart';

class WeatherController extends GetxController {
  /// ------------------------
  /// REACTIVE VARIABLES
  /// ------------------------

  final _someReactiveString = ''.obs;
  String get someReactiveString => _someReactiveString.value;
  set someReactiveString(String value) => _someReactiveString.value = value;

  /// ------------------------
  /// VARIABLES
  /// ------------------------

  var someString = '';

  /// ------------------------
  /// INIT
  /// ------------------------

  @override
  void onInit() {
    super.onInit();
  }

  /// ------------------------
  /// METHODS
  /// ------------------------

  void someMethod() {}
}
