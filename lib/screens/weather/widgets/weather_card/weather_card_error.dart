import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/location/location.dart';
import '../../../../util/color.dart';

class WeatherCardError extends StatelessWidget {
  final Location location;
  final bool useOpacity;
  final String error;

  const WeatherCardError({
    required this.location,
    required this.useOpacity,
    required this.error,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
        child: AnimatedOpacity(
          duration: PromajaDurations.opacityAnimation,
          curve: Curves.easeIn,
          opacity: useOpacity ? 0.45 : 1,
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  lightenColor(PromajaColors.red),
                  darkenColor(PromajaColors.red),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: AnimatedOpacity(
              duration: PromajaDurations.opacityAnimation,
              curve: Curves.easeIn,
              opacity: useOpacity ? 0 : 1,
              child: Animate(
                onPlay: (controller) => controller.loop(
                  count: 7,
                  reverse: true,
                ),
                effects: [
                  FadeEffect(
                    curve: Curves.easeIn,
                    duration: PromajaDurations.errorFadeAnimation,
                  ),
                ],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),

                    ///
                    /// DATE & LOCATION
                    ///
                    Column(
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          DateFormat.yMMMMd().format(DateTime.now()),
                          style: PromajaTextStyles.weatherCardLastUpdated,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          location.name,
                          style: PromajaTextStyles.currentLocation,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    ///
                    /// ERROR ICON
                    ///
                    Transform.scale(
                      scale: 1.2,
                      child: Image.asset(
                        PromajaIcons.tornado,
                        height: 176,
                        width: 176,
                      ),
                    ),

                    ///
                    /// ERROR
                    ///
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Column(
                        children: [
                          const Text(
                            'Error',
                            style: PromajaTextStyles.errorFetching,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            error,
                            style: PromajaTextStyles.currentWeather,
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    ///
                    /// ADDITIONAL INFO
                    ///
                    Container(
                      height: 64,
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
