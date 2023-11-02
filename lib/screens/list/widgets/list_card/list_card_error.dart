import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../util/color.dart';

class ListCardError extends StatelessWidget {
  final String locationName;
  final String error;
  final Function() onTap;

  const ListCardError({
    required this.locationName,
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
            highlightColor: PromajaColors.white.withOpacity(0.15),
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
                        Text(
                          locationName,
                          style: PromajaTextStyles.listLocation,
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
                      key: UniqueKey(),
                      onPlay: (controller) => controller.loop(reverse: true),
                      delay: 10.seconds,
                      effects: [
                        ScaleEffect(
                          curve: Curves.easeIn,
                          end: const Offset(1.5, 1.5),
                          duration: 60.seconds,
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
