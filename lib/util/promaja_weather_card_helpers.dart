import 'package:flutter/material.dart';

const weatherCardPageLoopBase = 10000;

int getWeatherCardLoopedPage({
  required PageController pageController,
  required int cardCount,
  required int cardIndex,
}) {
  if (cardCount <= 1) {
    return pageController.initialPage;
  }

  final currentPage = pageController.hasClients ? pageController.page?.round() ?? pageController.initialPage : pageController.initialPage;
  final targetPage = pageController.initialPage + cardIndex;
  final nearestCycleOffset = ((currentPage - targetPage) / cardCount).round() * cardCount;

  return targetPage + nearestCycleOffset;
}
