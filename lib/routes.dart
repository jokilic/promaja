import 'package:go_router/go_router.dart';

import 'screens/cities/cities_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/weather/weather_screen.dart';

///
/// All routes used in the application
///

final router = GoRouter(
  initialLocation: MyRoutes.weatherScreen,
  routes: [
    GoRoute(
      path: MyRoutes.onboardingScreen,
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: MyRoutes.weatherScreen,
      builder: (context, state) => WeatherScreen(),
    ),
    GoRoute(
      path: MyRoutes.citiesScreen,
      builder: (context, state) => CitiesScreen(),
    ),
  ],
);

///
/// All pages have their designated names which can be found here
///
class MyRoutes {
  static const onboardingScreen = '/onboarding_screen';
  static const weatherScreen = '/weather_screen';
  static const citiesScreen = '/cities_screen';
}
