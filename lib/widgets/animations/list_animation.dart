import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

///
/// Widget which is put as a parent of each widget rendered in a [ListView]
///

class ListAnimation extends StatelessWidget {
  final int index;
  final Widget widget;
  final Duration animationDuration;
  final double horizontalOffset;
  final double verticalOffset;
  final Curve curve;

  const ListAnimation({
    required this.index,
    required this.widget,
    this.animationDuration = const Duration(milliseconds: 300),
    this.horizontalOffset = 0,
    this.verticalOffset = 0,
    this.curve = Curves.easeIn,
  });

  @override
  Widget build(BuildContext context) => AnimationConfiguration.staggeredList(
        position: index,
        duration: animationDuration,
        child: SlideAnimation(
          curve: curve,
          horizontalOffset: horizontalOffset,
          verticalOffset: verticalOffset,
          child: FadeInAnimation(
            curve: curve,
            child: widget,
          ),
        ),
      );
}
