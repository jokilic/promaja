import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../models/settings/units/distance_speed_unit.dart';
import '../../models/settings/units/precipitation_unit.dart';
import '../../models/settings/units/pressure_unit.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../services/hive_service.dart';
import '../../util/spacing.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'cards_notifiers.dart';
import 'widgets/card/card_error.dart';
import 'widgets/card/card_widget.dart';

class CardsScreen extends ConsumerWidget {
  void cardSwiped({required int index, required WidgetRef ref}) {
    if (ref.read(cardIndexProvider) != index) {
      ref.read(cardMovingProvider.notifier).moving = false;
      ref.read(cardIndexProvider.notifier).currentIndex = index;

      if (ref.read(cardAdditionalControllerProvider).hasClients) {
        ref.read(cardAdditionalControllerProvider).jumpTo(0);
      }
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
      body: Animate(
        key: ValueKey(ref.read(navigationBarIndexProvider)),
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
            Padding(
              padding: EdgeInsets.only(
                bottom: getCardBottomPadding(context),
              ),
              child: cardCount == 0
                  ? CardError(
                      locationName: null,
                      error: 'noCards'.tr(),
                      isPhoneLocation: false,
                    )
                  : CardSwiper(
                      padding: EdgeInsets.zero,
                      controller: ref.watch(cardsSwiperControllerProvider),
                      isDisabled: cardCount <= 1,
                      duration: PromajaDurations.cardSwiperAnimation,
                      numberOfCardsDisplayed: min(cardCount, 4),
                      cardsCount: cardCount,
                      onSwipeDirectionChange: (horizontal, vertical) {
                        final isMoving = horizontal != CardSwiperDirection.none || vertical != CardSwiperDirection.none;

                        final movingNotifier = ref.read(cardMovingProvider.notifier);
                        final currentMoving = ref.read(cardMovingProvider);

                        if (currentMoving != isMoving) {
                          movingNotifier.moving = isMoving;
                        }
                      },
                      onSwipe: (previousIndex, index, __) {
                        cardSwiped(index: index ?? previousIndex, ref: ref);
                        return true;
                      },
                      cardBuilder: (_, cardIndex, __, ___) => CardWidget(
                        originalLocation: locations[cardIndex],
                        showCelsius: showCelsius,
                        showKph: showKph,
                        showMm: showMm,
                        showhPa: showhPa,
                      ),
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
