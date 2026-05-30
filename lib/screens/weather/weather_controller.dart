import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get_it/get_it.dart';

import '../../constants/durations.dart';
import '../../models/weather/hour_weather.dart';

// final getForecastWeatherProvider = FutureProvider.family<({ResponseForecastWeather? response, ResponseError? error, String? genericError}), ({Location location, int days})>(
//   (ref, forecastParameters) async => ref
//       .read(apiProvider)
//       .getForecastWeather(
//         query: '${forecastParameters.location.lat},${forecastParameters.location.lon}',
//         days: forecastParameters.days,
//       ),
//   name: 'GetForecastWeatherProvider',
// );

// class ActiveWeatherNotifier extends Notifier<Location?> {
//   @override
//   Location? build() {
//     final weatherList = ref.watch(hiveProvider);
//     final hiveService = ref.read(hiveProvider.notifier);
//     final weatherIndex = hiveService.getActiveLocationIndexFromBox();

//     Location? location;
//     try {
//       location = weatherList.elementAt(weatherIndex);
//     } catch (e) {
//       location = weatherList.elementAtOrNull(0);
//     }

//     return weatherList.isNotEmpty ? location : null;
//   }
// }

class WeatherController
    extends
        ValueNotifier<
          ({
            int index,
            bool isMoving,
            bool isVisible,
            HourWeather? activeHour,
          })
        >
    implements Disposable {
  WeatherController()
    : super((
        index: 0,
        isMoving: false,
        isVisible: true,
        activeHour: null,
      ));

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    cardSwiperController.dispose();
    cardHourAdditionalPageController.dispose();
  }

  ///
  /// VARIABLES
  ///

  late final cardSwiperController = CardSwiperController();
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
        // TODO: Possibility to pass null
        newActiveHour: null,
        newIsVisible: false,
      );

      scrollController.animateTo(
        0,
        duration: PromajaDurations.scrollAnimation,
        curve: Curves.easeIn,
      );
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
        (_) => scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: PromajaDurations.scrollAnimation,
          curve: Curves.easeIn,
        ),
      );
    }
  }

  /// Triggered when the card is being moved
  void onSwipeDirectionChange({required bool newIsMoving}) {
    if (value.isMoving != newIsMoving) {
      updateState(
        newIsMoving: newIsMoving,
      );
    }
  }

  /// Triggered when the user swipes card
  void cardSwiped({required int newIndex}) {
    /// There's a change in `index`
    if (value.index != newIndex) {
      updateState(
        newIndex: newIndex,
        newIsMoving: false,
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
    bool? newIsMoving,
    bool? newIsVisible,
    HourWeather? newActiveHour,
  }) => value = (
    index: newIndex ?? value.index,
    isMoving: newIsMoving ?? value.isMoving,
    isVisible: newIsVisible ?? value.isVisible,
    activeHour: newActiveHour ?? value.activeHour,
  );
}
