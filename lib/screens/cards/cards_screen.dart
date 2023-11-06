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
import '../../services/hive_service.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'cards_notifiers.dart';
import 'widgets/card/card_error.dart';
import 'widgets/card/card_widget.dart';

class CardsScreen extends ConsumerWidget {
  void cardSwiped({required int index, required WidgetRef ref}) {
    ref.read(cardMovingProvider.notifier).state = false;
    ref.read(cardIndexProvider.notifier).state = index;
    if (ref.read(cardAdditionalControllerProvider).hasClients) {
      ref.read(cardAdditionalControllerProvider).jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(cardIndexProvider);
    final locations = ref.watch(hiveProvider);
    final cardsCount = locations.length;

    return Scaffold(
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
            AppinioSwiper(
              loop: true,
              padding: const EdgeInsets.only(bottom: 24),
              isDisabled: cardsCount <= 1,
              duration: PromajaDurations.cardSwiperAnimation,
              backgroundCardsCount: min(cardsCount - 1, 3),
              cardsCount: cardsCount,
              onSwiping: (_) => ref.read(cardMovingProvider.notifier).state = true,
              onSwipeCancelled: () => ref.read(cardMovingProvider.notifier).state = false,
              onSwipe: (index, __) => cardSwiped(index: index, ref: ref),
              cardsBuilder: (_, cardIndex) {
                final location = locations.elementAtOrNull(cardIndex);

                /// Return proper [CardWidget]
                if (location != null) {
                  return CardWidget(
                    originalLocation: location,
                    useOpacity: index != cardIndex && !ref.watch(cardMovingProvider),
                  );
                }

                /// This should never happen, but if it does, return [CardError]
                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
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
                  count: cardsCount,
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
