import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get_it/get_it.dart';

class CurrentController extends ValueNotifier<({int index, bool isMoving})> implements Disposable {
  CurrentController()
    : super((
        index: 0,
        isMoving: false,
      ));

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    cardSwiperController.dispose();
    cardAdditionalPageController.dispose();
  }

  ///
  /// VARIABLES
  ///

  late final cardSwiperController = CardSwiperController();
  late final cardAdditionalPageController = PageController();

  ///
  /// METHODS
  ///

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
      );

      if (cardAdditionalPageController.hasClients) {
        cardAdditionalPageController.jumpTo(0);
      }
    }
  }

  /// Updates `state`
  void updateState({
    int? newIndex,
    bool? newIsMoving,
  }) => value = (
    index: newIndex ?? value.index,
    isMoving: newIsMoving ?? value.isMoving,
  );
}
