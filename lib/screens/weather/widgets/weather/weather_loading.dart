import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../models/location/location.dart';
import '../../../../util/color.dart';

class WeatherLoading extends StatelessWidget {
  final Location location;

  const WeatherLoading({
    required this.location,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.only(bottom: 24),
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
      );
}
