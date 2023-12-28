import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../util/color.dart';

class WeatherCardSummary extends StatelessWidget {
  final bool useOpacity;

  const WeatherCardSummary({
    required this.useOpacity,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: AnimatedOpacity(
          duration: PromajaDurations.opacityAnimation,
          curve: Curves.easeIn,
          opacity: useOpacity ? 0.45 : 1,
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  lightenColor(PromajaColors.indigo),
                  darkenColor(PromajaColors.indigo),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: AnimatedOpacity(
              duration: PromajaDurations.opacityAnimation,
              curve: Curves.easeIn,
              opacity: useOpacity ? 0 : 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  Column(
                    children: [
                      ///
                      /// TORNADO ICON
                      ///
                      Transform.scale(
                        scale: 1.2,
                        child: Image.asset(
                          PromajaIcons.tornado,
                          height: 176,
                          width: 176,
                        ),
                      ),

                      const SizedBox(height: 40),

                      ///
                      /// TEXT
                      ///
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        child: Text(
                          'Forecast summary will be here.',
                          style: PromajaTextStyles.settingsSubtitle,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 24),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: PromajaColors.white,
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: PromajaColors.indigo,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      );
}
