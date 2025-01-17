import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../util/color.dart';

class ListCardLoading extends StatelessWidget {
  final String locationName;
  final bool isPhoneLocation;
  final Function() onTap;

  const ListCardLoading({
    required this.locationName,
    required this.isPhoneLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              lightenColor(Colors.amberAccent),
              darkenColor(Colors.amberAccent),
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
                  /// LOCATION & LOADING
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
                                locationName,
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

                        /// Loading
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
                            height: 48,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: PromajaColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///
                  /// LOADING ICON
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
                      height: 88,
                      width: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PromajaColors.white.withValues(alpha: 0.5),
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
