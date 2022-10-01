import 'package:flutter/material.dart';

///
/// Widget which will animate the `child` with a fade effect
///

class FadeAnimation extends StatelessWidget {
  final double begin;
  final double end;
  final Duration duration;
  final double intervalStart;
  final double intervalEnd;
  final Curve curve;
  final Widget child;

  const FadeAnimation({
    required this.child,
    Key? key,
    this.begin = 0,
    this.end = 1,
    this.intervalStart = 0,
    this.intervalEnd = 1,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.easeIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: begin, end: end),
        duration: duration,
        curve: Interval(intervalStart, intervalEnd, curve: curve),
        child: child,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: child,
        ),
      );
}
