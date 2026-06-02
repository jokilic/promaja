import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../constants/durations.dart';
import '../models/settings/appearance/weather_card_layout.dart';

class PromajaWeatherCard extends StatelessWidget {
  final WeatherCardLayout weatherCardLayout;
  final int cardCount;
  final EdgeInsets padding;
  final CardSwiperController cardSwiperController;
  final CarouselController carouselController;
  final Function(int newIndex) onIndexChanged;
  final IndexedWidgetBuilder cardBuilder;

  const PromajaWeatherCard({
    required this.weatherCardLayout,
    required this.cardCount,
    required this.padding,
    required this.cardSwiperController,
    required this.carouselController,
    required this.onIndexChanged,
    required this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) => switch (weatherCardLayout) {
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
      cardBuilder: (context, cardIndex, _, __) => cardBuilder(
        context,
        cardIndex,
      ),
    ),
    WeatherCardLayout.carousel => Padding(
      padding: padding,
      child: CarouselView.weighted(
        controller: carouselController,
        scrollDirection: Axis.vertical,
        flexWeights: const [12, 1],
        itemSnapping: true,
        enableSplash: false,
        onIndexChanged: onIndexChanged,
        children: List.generate(
          cardCount,
          (cardIndex) => cardBuilder(
            context,
            cardIndex,
          ),
        ),
      ),
    ),
  };
}
