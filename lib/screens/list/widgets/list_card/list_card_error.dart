import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/location/location.dart';
import '../../../../util/color.dart';

class ListCardError extends StatelessWidget {
  final Location location;
  final bool isPhoneLocation;
  final String error;
  final Function() onTap;

  const ListCardError({
    required this.location,
    required this.isPhoneLocation,
    required this.error,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              lightenColor(PromajaColors.red),
              darkenColor(PromajaColors.red),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(50),
            splashColor: Colors.transparent,
            highlightColor: PromajaColors.white.withValues(alpha: 0.15),
            child: Container(
              height: 136,
              padding: const EdgeInsets.fromLTRB(32, 16, 24, 8),
              child: Row(
                children: [
                  ///
                  /// LOCATION & ERROR
                  ///
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Location
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                location.name,
                                style: PromajaTextStyles.listLocation,
                              ),
                            ),
                            if (isPhoneLocation) ...[
                              const SizedBox(width: 8),
                              Image.asset(
                                PromajaIcons.location,
                                height: 24,
                                width: 24,
                                color: PromajaColors.white,
                              ),
                            ],
                          ],
                        ),

                        /// Error data
                        Text(
                          error,
                          style: PromajaTextStyles.listErrorData,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  ///
                  /// ERROR ICON
                  ///
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Animate(
                      key: ValueKey(location),
                      onPlay: (controller) => controller.loop(reverse: true),
                      delay: PromajaDurations.weatherIconScaleDelay,
                      effects: [
                        ScaleEffect(
                          curve: Curves.easeIn,
                          end: const Offset(1.5, 1.5),
                          duration: PromajaDurations.weatherIconScalAnimation,
                        ),
                      ],
                      child: Transform.scale(
                        scale: 1.2,
                        child: Image.asset(
                          PromajaIcons.tornado,
                          height: 88,
                          width: 88,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
