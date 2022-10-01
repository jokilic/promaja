import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

///
/// [Column] widget which animates in a staggered fashion
///

class ColumnAnimation extends StatelessWidget {
  final List<Widget> children;
  final Duration animationDuration;
  final double horizontalOffset;
  final double verticalOffset;
  final Curve curve;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const ColumnAnimation({
    required this.children,
    this.animationDuration = const Duration(milliseconds: 300),
    this.horizontalOffset = 0,
    this.verticalOffset = 0,
    this.curve = Curves.easeIn,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) => AnimationLimiter(
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: AnimationConfiguration.toStaggeredList(
            duration: animationDuration,
            childAnimationBuilder: (widget) => SlideAnimation(
              curve: curve,
              horizontalOffset: horizontalOffset,
              verticalOffset: verticalOffset,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: children,
          ),
        ),
      );
}
