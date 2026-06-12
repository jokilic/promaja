import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../constants/durations.dart';
import '../models/settings/appearance/weather_card_layout.dart';

class PromajaWeatherCard extends StatefulWidget {
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
  State<PromajaWeatherCard> createState() => PromajaWeatherCardState();
}

class PromajaWeatherCardState extends State<PromajaWeatherCard> {
  var isInteracting = false;

  bool shouldScaleForPointer(PointerDownEvent event) {
    final hitTestResult = HitTestResult();

    WidgetsBinding.instance.hitTestInView(
      hitTestResult,
      event.position,
      event.viewId,
    );

    return !hitTestResult.path.any(
      (entry) => entry.target is PromajaWeatherCardScaleIgnoreRenderObject,
    );
  }

  void updateInteractionFromPointerDown(PointerDownEvent event) => updateInteraction(
    shouldScaleForPointer(event),
  );

  void updateInteraction(bool newIsInteracting) {
    if (isInteracting == newIsInteracting) {
      return;
    }

    setState(
      () => isInteracting = newIsInteracting,
    );
  }

  Widget buildScaledCard({
    required int cardIndex,
    required Widget child,
  }) => AnimatedScale(
    scale: isInteracting && cardIndex == widget.activeIndex ? 0.95 : 1,
    duration: PromajaDurations.weatherCardScaleAnimation,
    curve: Curves.easeIn,
    child: child,
  );

  double pageOffsetFor(int pageIndex) {
    final currentPage = widget.pageController.hasClients
        ? widget.pageController.page ?? widget.pageController.initialPage.toDouble()
        : widget.pageController.initialPage.toDouble();

    return (pageIndex - currentPage).clamp(-1.0, 1.0).toDouble();
  }

  Alignment cubeAlignmentFor({
    required double pageOffset,
    required bool isHorizontal,
  }) {
    if (isHorizontal) {
      return pageOffset < 0 ? Alignment.centerRight : Alignment.centerLeft;
    }

    return pageOffset < 0 ? Alignment.bottomCenter : Alignment.topCenter;
  }

  Widget buildTransformedPageCard({
    required int pageIndex,
    required int cardIndex,
    required Widget child,
  }) => AnimatedBuilder(
    animation: widget.pageController,
    child: buildScaledCard(
      cardIndex: cardIndex,
      child: child,
    ),
    builder: (_, child) {
      final pageOffset = pageOffsetFor(pageIndex);

      final isHorizontal = widget.weatherCardLayout == WeatherCardLayout.horizontal;

      final distanceFromCenter = pageOffset.abs();
      final rotation = pageOffset * pi / 2;

      final separation = sin(distanceFromCenter * pi) * 12;
      final cubeTransform = Matrix4.identity()
        ..setEntry(3, 2, 0.0014)
        ..translate(
          isHorizontal ? pageOffset.sign * separation : 0.0,
          isHorizontal ? 0.0 : pageOffset.sign * separation,
        );

      if (isHorizontal) {
        cubeTransform.rotateY(-rotation);
      } else {
        cubeTransform.rotateX(rotation);
      }

      return Transform(
        alignment: cubeAlignmentFor(
          pageOffset: pageOffset,
          isHorizontal: isHorizontal,
        ),
        transform: cubeTransform,
        child: child,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final cards = List.generate(
      widget.cardCount,
      (index) => widget.cardBuilder(
        context,
        index,
      ),
      growable: false,
    );

    final numberOfCardsDisplayed = min(widget.cardCount, 4);

    if (widget.cardCount == 0) {
      return const SizedBox.shrink();
    }

    if (widget.cardCount == 1 && widget.weatherCardLayout != WeatherCardLayout.stacked) {
      return Listener(
        onPointerDown: updateInteractionFromPointerDown,
        onPointerUp: (_) => updateInteraction(false),
        onPointerCancel: (_) => updateInteraction(false),
        child: Padding(
          padding: widget.padding,
          child: buildScaledCard(
            cardIndex: 0,
            child: cards.first,
          ),
        ),
      );
    }

    return switch (widget.weatherCardLayout) {
      WeatherCardLayout.stacked => Listener(
        onPointerDown: updateInteractionFromPointerDown,
        onPointerUp: (_) => updateInteraction(false),
        onPointerCancel: (_) => updateInteraction(false),
        child: CardSwiper(
          backCardOffset: const Offset(0, 48),
          padding: widget.padding,
          controller: widget.cardSwiperController,
          isDisabled: widget.cardCount <= 1,
          duration: PromajaDurations.cardSwiperAnimation,
          numberOfCardsDisplayed: numberOfCardsDisplayed,
          cardsCount: widget.cardCount,
          onSwipe: (previousIndex, index, _) {
            updateInteraction(false);
            widget.onIndexChanged(index ?? previousIndex);
            return true;
          },
          cardBuilder: (_, cardIndex, _, __) => buildScaledCard(
            cardIndex: cardIndex,
            child: cards[cardIndex],
          ),
        ),
      ),
      WeatherCardLayout.horizontal || WeatherCardLayout.vertical => Listener(
        onPointerDown: updateInteractionFromPointerDown,
        onPointerUp: (_) => updateInteraction(false),
        onPointerCancel: (_) => updateInteraction(false),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.depth != 0) {
              return false;
            }

            if (notification is ScrollStartNotification) {
              updateInteraction(true);
            } else if (notification is ScrollEndNotification) {
              updateInteraction(false);
            }

            return false;
          },
          child: Padding(
            padding: widget.padding,
            child: PageView.builder(
              scrollDirection: widget.weatherCardLayout == WeatherCardLayout.horizontal ? Axis.horizontal : Axis.vertical,
              controller: widget.pageController,
              onPageChanged: (pageIndex) => widget.onIndexChanged(
                (pageIndex - widget.pageController.initialPage) % widget.cardCount,
              ),
              allowImplicitScrolling: true,
              scrollCacheExtent: ScrollCacheExtent.viewport(
                (numberOfCardsDisplayed - 1).toDouble(),
              ),
              itemBuilder: (_, pageIndex) {
                final cardIndex = (pageIndex - widget.pageController.initialPage) % widget.cardCount;

                return buildTransformedPageCard(
                  pageIndex: pageIndex,
                  cardIndex: cardIndex,
                  child: cards[cardIndex],
                );
              },
            ),
          ),
        ),
      ),
    };
  }
}

class PromajaWeatherCardScaleIgnore extends SingleChildRenderObjectWidget {
  const PromajaWeatherCardScaleIgnore({
    required super.child,
  });

  @override
  PromajaWeatherCardScaleIgnoreRenderObject createRenderObject(BuildContext context) => PromajaWeatherCardScaleIgnoreRenderObject();
}

class PromajaWeatherCardScaleIgnoreRenderObject extends RenderProxyBox {
  @override
  bool hitTestSelf(Offset position) => true;
}
