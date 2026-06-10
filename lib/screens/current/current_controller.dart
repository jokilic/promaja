// ignore_for_file: use_setters_to_change_properties

import 'package:flip_page/flip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get_it/get_it.dart';

import '../../util/promaja_weather_card_helpers.dart';

class CurrentController extends ValueNotifier<int> implements Disposable {
  CurrentController() : super(0);

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    cardSwiperController.dispose();
    pageController.dispose();
    flipPageController.dispose();
    cardAdditionalPageController.dispose();
  }

  ///
  /// VARIABLES
  ///

  late final cardSwiperController = CardSwiperController();
  late final pageController = PageController(
    initialPage: weatherCardPageLoopBase,
  );
  late final flipPageController = FlipPageController();
  late final cardAdditionalPageController = PageController();

  ///
  /// METHODS
  ///

  /// Triggered when the user swipes card
  void cardSwiped({required int newIndex}) {
    /// There's a change in `index`
    if (value != newIndex) {
      updateState(
        newIndex: newIndex,
      );

      if (cardAdditionalPageController.hasClients) {
        cardAdditionalPageController.jumpTo(0);
      }
    }
  }

  /// Updates `state`
  void updateState({
    required int newIndex,
  }) => value = newIndex;
}
