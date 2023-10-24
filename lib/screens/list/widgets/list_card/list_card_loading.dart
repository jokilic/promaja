import 'package:animated_shimmer/animated_shimmer.dart';
import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_styles.dart';
import '../../../../util/color.dart';
import '../../../../widgets/fade_animation.dart';

class ListCardLoading extends StatelessWidget {
  final String locationName;
  final Function() onTap;

  const ListCardLoading({
    required this.locationName,
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
            highlightColor: PromajaColors.white.withOpacity(0.15),
            child: Container(
              height: 136,
              padding: const EdgeInsets.fromLTRB(32, 16, 24, 8),
              child: FadeAnimation(
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
                          Text(
                            locationName,
                            style: PromajaTextStyles.listLocation,
                          ),

                          /// Loading
                          AnimatedShimmer(
                            height: 48,
                            width: 80,
                            startColor: PromajaColors.white.withOpacity(0.5),
                            endColor: PromajaColors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                    ),

                    ///
                    /// LOADING ICON
                    ///
                    AnimatedShimmer.round(
                      size: 96,
                      startColor: PromajaColors.white.withOpacity(0.5),
                      endColor: PromajaColors.white.withOpacity(0.25),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
