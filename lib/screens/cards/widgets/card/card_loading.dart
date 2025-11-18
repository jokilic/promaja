import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../models/location/location.dart';
import '../../../../util/color.dart';

class CardLoading extends StatelessWidget {
  final Location location;

  const CardLoading({
    required this.location,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: MediaQuery.sizeOf(context).width,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(40),
      ),
      gradient: LinearGradient(
        colors: [
          lightenColor(Colors.amberAccent),
          darkenColor(Colors.amberAccent),
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...List.generate(10, (index) => const SizedBox.shrink()),

        ///
        /// LAST UPDATED & LOCATION
        ///
        Animate(
          onPlay: (controller) => controller.loop(
            reverse: true,
            min: 0.6,
          ),
          effects: [
            FadeEffect(
              curve: Curves.easeIn,
              duration: PromajaDurations.shimmerAnimation,
            ),
          ],
          child: Column(
            children: [
              Container(
                height: 16,
                width: 104,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: PromajaColors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 32,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: PromajaColors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),

        ...List.generate(5, (index) => const SizedBox.shrink()),

        ///
        /// WEATHER ICON
        ///
        Animate(
          onPlay: (controller) => controller.loop(
            reverse: true,
            min: 0.6,
          ),
          effects: [
            FadeEffect(
              curve: Curves.easeIn,
              duration: PromajaDurations.shimmerAnimation,
            ),
          ],
          child: Container(
            height: 176,
            width: 176,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PromajaColors.white.withValues(alpha: 0.5),
            ),
          ),
        ),

        ...List.generate(5, (index) => const SizedBox.shrink()),

        ///
        /// TEMPERATURE & WEATHER
        ///
        Animate(
          onPlay: (controller) => controller.loop(
            reverse: true,
            min: 0.6,
          ),
          effects: [
            FadeEffect(
              curve: Curves.easeIn,
              duration: PromajaDurations.shimmerAnimation,
            ),
          ],
          child: Column(
            children: [
              Container(
                height: 104,
                width: 144,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: PromajaColors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 32,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: PromajaColors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
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
  );
}
