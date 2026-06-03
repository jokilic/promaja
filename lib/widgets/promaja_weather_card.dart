import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../constants/durations.dart';
import '../models/settings/appearance/weather_card_layout.dart';

class PromajaWeatherCard extends StatelessWidget {
  final WeatherCardLayout weatherCardLayout;
  final int cardCount;
  final int activeIndex;
  final EdgeInsets padding;
  final CardSwiperController cardSwiperController;
  final PageController pageController;
  final Function(int newIndex) onIndexChanged;
  final IndexedWidgetBuilder cardBuilder;

  const PromajaWeatherCard({
    required this.weatherCardLayout,
    required this.cardCount,
    required this.activeIndex,
    required this.padding,
    required this.cardSwiperController,
    required this.pageController,
    required this.onIndexChanged,
    required this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    /// [flutter_card_swiper] calls `cardBuilder` while a card is dragged, so keep the
    /// card widget instances stable for the duration of this build
    final cards = List.generate(
      cardCount,
      (index) => cardBuilder(
        context,
        index,
      ),
      growable: false,
    );

    return switch (weatherCardLayout) {
      WeatherCardLayout.stacked => CardSwiper(
        backCardOffset: const Offset(0, 48),
        padding: padding,
        controller: cardSwiperController,
        isDisabled: cardCount <= 1,
        duration: PromajaDurations.cardSwiperAnimation,
        numberOfCardsDisplayed: min(cardCount, 4),
        cardsCount: cardCount,
        onSwipe: (previousIndex, index, _) {
          onIndexChanged(index ?? previousIndex);
          return true;
        },
        cardBuilder: (_, cardIndex, _, __) => cards[cardIndex],
      ),
      WeatherCardLayout.horizontal || WeatherCardLayout.vertical => Padding(
        padding: padding,
        child: PageView.builder(
          scrollDirection: weatherCardLayout == WeatherCardLayout.horizontal ? Axis.horizontal : Axis.vertical,
          controller: pageController,
          onPageChanged: onIndexChanged,
          itemCount: cardCount,
          itemBuilder: (_, index) => cards[index],
        ),
      ),
    };
  }
}
