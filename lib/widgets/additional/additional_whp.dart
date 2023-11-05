import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/icons.dart';
import 'additional_value_widget.dart';

class AdditionalWHP extends StatelessWidget {
  final int? windDegree;
  final double windKph;
  final int humidity;
  final double precipitation;
  final bool useAnimations;

  const AdditionalWHP({
    required this.windKph,
    required this.humidity,
    required this.precipitation,
    this.windDegree,
    this.useAnimations = true,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: PromajaColors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(50),
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: AnimateList(
            delay: useAnimations ? PromajaDurations.additionalWeatherDataAnimationDelay : Duration.zero,
            interval: useAnimations ? PromajaDurations.additionalWeatherListInterval : Duration.zero,
            effects: [
              FadeEffect(
                curve: Curves.easeIn,
                duration: useAnimations ? PromajaDurations.fadeAnimation : Duration.zero,
              ),
            ],
            children: [
              ///
              /// WIND
              ///
              Expanded(
                child: AdditionalValueWidget(
                  icon: PromajaIcons.wind,
                  value: '${windKph.round()} km/h',
                  description: 'wind'.tr(),
                  rotation: windDegree,
                ),
              ),

              Container(
                height: 40,
                width: 0.5,
                color: PromajaColors.white.withOpacity(0.4),
              ),

              ///
              /// HUMIDITY
              ///
              Expanded(
                child: AdditionalValueWidget(
                  icon: PromajaIcons.humidity,
                  value: '$humidity%',
                  description: 'humidity'.tr(),
                ),
              ),

              Container(
                height: 40,
                width: 0.5,
                color: PromajaColors.white.withOpacity(0.4),
              ),

              ///
              /// PRECIPITATION
              ///
              Expanded(
                child: AdditionalValueWidget(
                  icon: PromajaIcons.precipitation,
                  value: '${precipitation.round()} mm',
                  description: 'precipitation'.tr(),
                ),
              ),
            ],
          ),
        ),
      );
}
