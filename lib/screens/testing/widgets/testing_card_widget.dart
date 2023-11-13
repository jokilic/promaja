import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';
import '../../../util/color.dart';

class TestingCardWidget extends StatelessWidget {
  final Color backgroundColor;
  final Function() onTap;
  final String weatherIcon;
  final String description;

  const TestingCardWidget({
    required this.backgroundColor,
    required this.onTap,
    required this.weatherIcon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              lightenColor(backgroundColor),
              darkenColor(backgroundColor),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///
                  /// DESCRIPTION
                  ///
                  Expanded(
                    child: Text(
                      description,
                      style: PromajaTextStyles.testingListDescription,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),

                  const SizedBox(width: 32),

                  ///
                  /// WEATHER ICON
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
                          weatherIcon,
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
