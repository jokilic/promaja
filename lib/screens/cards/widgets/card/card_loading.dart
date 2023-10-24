import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../constants/colors.dart';
import '../../../../models/location/location.dart';
import '../../../../util/color.dart';

class CardLoading extends StatelessWidget {
  final Location location;
  final bool useOpacity;

  const CardLoading({
    required this.location,
    required this.useOpacity,
  });

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        opacity: useOpacity ? 0.45 : 1,
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                lightenColor(Colors.amberAccent),
                darkenColor(Colors.amberAccent),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            opacity: useOpacity ? 0 : 1,
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 400),
                  childAnimationBuilder: (widget) => FadeInAnimation(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                    child: widget,
                  ),
                  children: [
                    ...List.generate(10, (index) => const SizedBox.shrink()),

                    ///
                    /// LAST UPDATED & LOCATION
                    ///
                    Column(
                      children: [
                        AnimatedShimmer(
                          height: 16,
                          width: 104,
                          startColor: PromajaColors.white.withOpacity(0.5),
                          endColor: PromajaColors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 16),
                        AnimatedShimmer(
                          height: 32,
                          width: 200,
                          startColor: PromajaColors.white.withOpacity(0.5),
                          endColor: PromajaColors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),

                    ...List.generate(5, (index) => const SizedBox.shrink()),

                    ///
                    /// WEATHER ICON
                    ///
                    AnimatedShimmer.round(
                      size: 176,
                      startColor: PromajaColors.white.withOpacity(0.5),
                      endColor: PromajaColors.white.withOpacity(0.25),
                    ),

                    ...List.generate(5, (index) => const SizedBox.shrink()),

                    ///
                    /// TEMPERATURE & WEATHER
                    ///
                    Column(
                      children: [
                        AnimatedShimmer(
                          width: 144,
                          height: 104,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 16),
                        AnimatedShimmer(
                          height: 32,
                          width: 200,
                          startColor: PromajaColors.white.withOpacity(0.5),
                          endColor: PromajaColors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),

                    ///
                    /// ADDITIONAL INFO
                    ///
                    Container(
                      height: 144,
                      color: Colors.transparent,
                      margin: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
