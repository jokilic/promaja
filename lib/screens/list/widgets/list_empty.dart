import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/durations.dart';
import '../../../constants/icons.dart';
import '../../../constants/text_styles.dart';
import 'add_location/add_location_widget.dart';

class ListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: AddLocationWidget(),
          ),
          Column(
            children: [
              Animate(
                onPlay: (controller) => controller.loop(reverse: true),
                delay: 10.seconds,
                effects: [
                  ScaleEffect(
                    curve: Curves.easeIn,
                    end: const Offset(1.5, 1.5),
                    duration: 60.seconds,
                  ),
                ],
                child: Animate(
                  delay: PromajaDurations.cardWeatherIconAnimationDelay,
                  effects: [
                    FlipEffect(
                      curve: Curves.easeIn,
                      duration: PromajaDurations.fadeAnimation,
                    ),
                  ],
                  child: Transform.scale(
                    scale: 1.2,
                    child: Image.asset(
                      PromajaIcons.icon,
                      height: 176,
                      width: 176,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'startUsing1'.tr()),
                      TextSpan(
                        text: 'startUsing2'.tr(),
                        style: PromajaTextStyles.noLocationsPromaja,
                      ),
                      TextSpan(text: 'startUsing3'.tr()),
                    ],
                  ),
                  style: PromajaTextStyles.noLocations,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox.shrink()
        ],
      );
}
