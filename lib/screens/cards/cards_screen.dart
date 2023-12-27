import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' as animate;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../models/location/location.dart';
import '../../models/promaja_log/promaja_log_level.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/precipitation_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../services/hive_service.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'cards_notifiers.dart';
import 'widgets/card/card_error.dart';
import 'widgets/card/card_widget.dart';

class CardsScreen extends ConsumerWidget {
  void cardSwiped({required int index, required WidgetRef ref}) {
    if (ref.read(cardIndexProvider) != index) {
      ref.read(cardMovingProvider.notifier).state = false;
      ref.read(cardIndexProvider.notifier).state = index;
      if (ref.read(cardAdditionalControllerProvider).hasClients) {
        ref.read(cardAdditionalControllerProvider).jumpTo(0);
      }

      final activeLocation = ref.read(hiveProvider)[index];

      ref.read(hiveProvider.notifier).logPromajaEvent(
            text: 'Card swipe -> ${activeLocation.name}, ${activeLocation.country}',
            logLevel: PromajaLogLevel.currentWeather,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(cardIndexProvider);
    final locations = ref.watch(hiveProvider);
    final cardCount = locations.length;

    final settings = ref.watch(hiveProvider.notifier).getPromajaSettingsFromBox();

    final showCelsius = settings.unit.temperature == TemperatureUnit.celsius;
    final showKph = settings.unit.distanceSpeed == DistanceSpeedUnit.kilometers;
    final showMm = settings.unit.precipitation == PrecipitationUnit.millimeters;
    final showhPa = settings.unit.pressure == PressureUnit.hectopascal;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: PromajaNavigationBar(),
      body: animate.Animate(
        key: ValueKey(ref.read(navigationBarIndexProvider)),
        effects: [
          animate.FadeEffect(
            curve: Curves.easeIn,
            duration: PromajaDurations.fadeAnimation,
          ),
        ],
        child: Stack(
          children: [
            ///
            /// WEATHER
            ///
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).top + 80),
              child: AppinioSwiper(
                loop: true,
                controller: ref.watch(appinioControllerProvider),
                onCardPositionChanged: (_) {
                  if (!ref.read(cardMovingProvider)) {
                    ref.read(cardMovingProvider.notifier).state = true;
                  }
                },
                onSwipeEnd: (_, index, __) => cardSwiped(index: index, ref: ref),
                onSwipeCancelled: (_) => ref.read(cardMovingProvider.notifier).state = false,
                backgroundCardOffset: const Offset(0, 44),
                isDisabled: cardCount <= 1,
                duration: PromajaDurations.cardSwiperAnimation,
                backgroundCardCount: min(cardCount - 1, 3),
                cardCount: cardCount,
                cardBuilder: (_, cardIndex) {
                  final location = locations.elementAtOrNull(cardIndex);

                  /// Return proper [CardWidget]
                  if (location != null) {
                    return CardWidget(
                      originalLocation: location,
                      useOpacity: index != cardIndex && !ref.watch(cardMovingProvider),
                      showCelsius: showCelsius,
                      showKph: showKph,
                      showMm: showMm,
                      showhPa: showhPa,
                    );
                  }

                  /// This should never happen, but if it does, return [CardError]
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CardError(
                      location: Location(
                        country: '---',
                        lat: 0,
                        lon: 0,
                        name: '---',
                        region: '---',
                      ),
                      error: 'noMoreLocations'.tr(),
                      useOpacity: index != cardIndex && !ref.watch(cardMovingProvider),
                      isPhoneLocation: false,
                    ),
                  );
                },
              ),
            ),

            ///
            /// DOTS
            ///
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
                    dotColor: PromajaColors.black.withOpacity(0.25),
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
