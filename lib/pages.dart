import 'package:get/get.dart';

import 'screens/cities/cities_binding.dart';
import 'screens/cities/cities_screen.dart';
import 'screens/weather/weather_binding.dart';
import 'screens/weather/weather_screen.dart';

///
/// All pages used in the application
/// Also linked to the relevant bindings in order to
/// initialize / dispose proper controllers when neccesarry
///

final pages = [
  GetPage(
    name: MyRoutes.weatherScreen,
    page: WeatherScreen.new,
    binding: WeatherBinding(),
  ),
  GetPage(
    name: MyRoutes.citiesScreen,
    page: CitiesScreen.new,
    binding: CitiesBinding(),
  ),
];

///
/// All pages have their designated names which can be found here
///
class MyRoutes {
  static const weatherScreen = '/weather_screen';
  static const citiesScreen = '/cities_screen';
}
