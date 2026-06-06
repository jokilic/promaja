import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../models/settings/appearance/weather_card_layout.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/precipitation_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../services/hive_service.dart';
import '../../util/dependencies.dart';
import '../../util/spacing.dart';
import '../../widgets/promaja_navigation_bar.dart';
import '../../widgets/promaja_weather_card.dart';
import 'current_controller.dart';
import 'widgets/current_error.dart';
import 'widgets/current_widget.dart';

class CurrentScreen extends WatchingStatefulWidget {
  @override
  State<CurrentScreen> createState() => _CurrentScreenState();
}

class _CurrentScreenState extends State<CurrentScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<CurrentController>(
      CurrentController.new,
    );
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<CurrentController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hive = getIt.get<HiveService>();
    final current = getIt.get<CurrentController>();

    final locations = watchIt<HiveService>().value;
    final cardCount = locations.length;

    final settings = hive.getPromajaSettingsFromBox();

    final showCelsius = settings.unit.temperature == TemperatureUnit.celsius;
    final showKph = settings.unit.distanceSpeed == DistanceSpeedUnit.kilometers;
    final showMm = settings.unit.precipitation == PrecipitationUnit.millimeters;
    final showhPa = settings.unit.pressure == PressureUnit.hectopascal;

    final index = watchIt<CurrentController>().value;

    final weatherCardLayout = settings.appearance.weatherCardLayout;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: PromajaNavigationBar(),
      body: Animate(
        effects: [
          FadeEffect(
            curve: Curves.easeIn,
            duration: PromajaDurations.fadeAnimation,
          ),
        ],
        child: Stack(
          children: [
            ///
            /// WEATHER
            ///
            if (cardCount == 0)
              Padding(
                padding: EdgeInsets.only(
                  bottom: getCurrentCardBottomPadding(context),
                ),
                child: CurrentError(
                  originalLocationName: null,
                  error: 'noCards'.tr(),
                  isPhoneLocation: false,
                ),
              )
            else
              PromajaWeatherCard(
                weatherCardLayout: weatherCardLayout,
                cardCount: cardCount,
                activeIndex: index,
                padding: EdgeInsets.only(
                  bottom: getCurrentCardBottomPadding(context),
                ),
                cardSwiperController: current.cardSwiperController,
                pageController: current.pageController,
                onIndexChanged: (index) => current.cardSwiped(
                  newIndex: index,
                ),
                cardBuilder: (_, cardIndex) => CurrentWidget(
                  key: weatherCardLayout == WeatherCardLayout.stacked ? GlobalObjectKey(cardIndex) : null,
                  originalLocation: locations[cardIndex],
                  showCelsius: showCelsius,
                  showKph: showKph,
                  showMm: showMm,
                  showhPa: showhPa,
                ),
              ),

            ///
            /// DOTS
            ///
            if (cardCount != 0)
              Positioned(
                right: 16,
                top: -160,
                bottom: 0,
                child: Align(
                  child: AnimatedSmoothIndicator(
                    activeIndex: index,
                    count: cardCount,
                    effect: WormEffect(
                      activeDotColor: PromajaColors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                      dotColor: PromajaColors.black.withValues(alpha: 0.25),
                    ),
                    axisDirection: Axis.vertical,
                    curve: Curves.easeIn,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
