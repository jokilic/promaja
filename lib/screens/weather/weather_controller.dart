import 'package:flip_page/flip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get_it/get_it.dart';

import '../../constants/durations.dart';
import '../../models/weather/hour_weather.dart';
import '../../util/null_state.dart';
import '../../util/promaja_weather_card_helpers.dart';

class WeatherController
    extends
        ValueNotifier<
          ({
            int index,
            bool isVisible,
            HourWeather? activeHour,
          })
        >
    implements Disposable {
  WeatherController()
    : super((
        index: 0,
        isVisible: true,
        activeHour: null,
      ));

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    cardSwiperController.dispose();
    pageController.dispose();
    flipPageController.dispose();
    cardScrollController.dispose();
    cardHourAdditionalPageController.dispose();
  }

  ///
  /// VARIABLES
  ///

  late final cardSwiperController = CardSwiperController();
  late final pageController = PageController(
    initialPage: weatherCardPageLoopBase,
  );
  late final flipPageController = FlipPageController();
  late final cardScrollController = ScrollController();
  late final cardHourAdditionalPageController = PageController();

  ///
  /// METHODS
  ///

  /// Triggered when the user presses an hour
  void weatherCardHourPressed({
    required HourWeather? activeHourWeather,
    required HourWeather hourWeather,
    required int index,
    required ScrollController scrollController,
  }) {
    /// User pressed already active hour
    /// Disable active hour and scroll up
    if (activeHourWeather == hourWeather) {
      updateState(
        newActiveHour: null,
        newIsVisible: false,
      );

      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: PromajaDurations.scrollAnimation,
          curve: Curves.easeIn,
        );
      }
    }
    /// User pressed inactive hour
    /// Enable active hour and scroll down
    else {
      updateState(
        newActiveHour: hourWeather,
        newIsVisible: true,
      );

      if (cardHourAdditionalPageController.hasClients) {
        cardHourAdditionalPageController.jumpTo(0);
      }

      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: PromajaDurations.scrollAnimation,
              curve: Curves.easeIn,
            );
          }
        },
      );
    }
  }

  /// Triggered when the user swipes card
  void cardSwiped({required int newIndex}) {
    /// There's a change in `index`
    if (value.index != newIndex) {
      updateState(
        newIndex: newIndex,
        newIsVisible: false,
      );

      if (cardHourAdditionalPageController.hasClients) {
        cardHourAdditionalPageController.jumpTo(0);
      }
    }
  }

  /// Updates `state`
  void updateState({
    int? newIndex,
    bool? newIsVisible,
    Object? newActiveHour = nullStateNoChange,
  }) => value = (
    index: newIndex ?? value.index,
    isVisible: newIsVisible ?? value.isVisible,
    activeHour: identical(newActiveHour, nullStateNoChange) ? value.activeHour : newActiveHour as HourWeather?,
  );
}
