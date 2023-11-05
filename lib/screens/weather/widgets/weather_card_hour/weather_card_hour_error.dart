import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../util/color.dart';

class WeatherCardHourError extends StatelessWidget {
  final Function() onPressed;
  final bool useOpacity;

  const WeatherCardHourError({
    required this.onPressed,
    required this.useOpacity,
  });

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        duration: PromajaDurations.opacityAnimation,
        curve: Curves.easeIn,
        opacity: useOpacity ? 0 : 1,
        child: Container(
          width: MediaQuery.sizeOf(context).width / 4 - 16,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Stack(
            children: [
              ///
              /// MAIN CONTENT
              ///
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      lightenColor(PromajaColors.red),
                      darkenColor(PromajaColors.red),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///
                    /// ERROR
                    ///
                    Text(
                      'Error',
                      style: PromajaTextStyles.weatherCardHourLastUpdated,
                      textAlign: TextAlign.center,
                    ),

                    ///
                    /// WEATHER ICON
                    ///
                    Animate(
                      key: UniqueKey(),
                      onPlay: (controller) => controller.loop(reverse: true),
                      delay: 10.seconds,
                      effects: [
                        ScaleEffect(
                          curve: Curves.easeIn,
                          end: const Offset(1.15, 1.15),
                          duration: 60.seconds,
                        ),
                      ],
                      child: Transform.scale(
                        scale: 1.2,
                        child: Image.asset(
                          PromajaIcons.tornado,
                          height: 32,
                          width: 32,
                        ),
                      ),
                    ),

                    ///
                    /// EMPTY SPACE
                    ///
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              ///
              /// INKWELL RIPPLE
              ///
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onPressed,
                    borderRadius: BorderRadius.circular(32),
                    splashColor: Colors.transparent,
                    highlightColor: PromajaColors.white.withOpacity(0.15),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
