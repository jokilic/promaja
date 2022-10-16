import 'screens/cities/cities_screen.dart';
import 'screens/weather/weather_screen.dart';

///
/// All routes used in the application
///

final routes = {
  MyRoutes.weatherScreen: (context) => WeatherScreen(),
  MyRoutes.citiesScreen: (context) => CitiesScreen(),
};

///
/// All pages have their designated names which can be found here
///
class MyRoutes {
  static const weatherScreen = '/weather_screen';
  static const citiesScreen = '/cities_screen';
}
