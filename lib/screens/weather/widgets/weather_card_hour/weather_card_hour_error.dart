import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../util/color.dart';

class WeatherCardHourError extends StatelessWidget {
  final Function() onPressed;

  const WeatherCardHourError({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.sizeOf(context).width / 4 - 16,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(
          alignment: Alignment.center,
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
                    'error'.tr(),
                    style: PromajaTextStyles.weatherCardHourHour,
                    textAlign: TextAlign.center,
                  ),

                  ///
                  /// WEATHER ICON
                  ///
                  Animate(
                    key: const ValueKey(-1),
                    onPlay: (controller) => controller.loop(reverse: true),
                    delay: PromajaDurations.weatherIconScaleDelay,
                    effects: [
                      ScaleEffect(
                        curve: Curves.easeIn,
                        end: const Offset(1.15, 1.15),
                        duration: PromajaDurations.weatherIconScalAnimation,
                      ),
                    ],
                    child: Transform.scale(
                      scale: 1.35,
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
                  highlightColor: PromajaColors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
          ],
        ),
      );
}
