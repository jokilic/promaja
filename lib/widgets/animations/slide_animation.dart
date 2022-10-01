import 'package:flutter/material.dart';

///
/// Widget which will animate the `child` with a slide effect
///

class SlideAnimation extends StatelessWidget {
  final Offset begin;
  final Offset end;
  final double intervalStart;
  final double intervalEnd;
  final Duration duration;
  final Curve curve;
  final Widget child;

  const SlideAnimation({
    required this.child,
    Key? key,
    this.begin = const Offset(250, 0),
    this.end = Offset.zero,
    this.intervalStart = 0,
    this.intervalEnd = 1,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.easeIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(begin: begin, end: end),
        duration: duration,
        curve: Interval(intervalStart, intervalEnd, curve: curve),
        child: child,
        builder: (context, value, child) => Transform.translate(
          offset: value,
          child: child,
        ),
      );
}
