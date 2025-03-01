import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/icons.dart';
import 'additional_value_widget.dart';

class AdditionalWPF extends StatelessWidget {
  final int? windDegree;
  final String windText;
  final String precipitationText;
  final double feelsLikeTemperature;
  final bool useAnimations;

  const AdditionalWPF({
    required this.windText,
    required this.precipitationText,
    required this.feelsLikeTemperature,
    this.windDegree,
    this.useAnimations = true,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: PromajaColors.black.withValues(alpha: 0.4),
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
                  value: windText,
                  description: 'wind'.tr(),
                  rotation: windDegree,
                ),
              ),

              Container(
                height: 40,
                width: 0.5,
                color: PromajaColors.white.withValues(alpha: 0.4),
              ),

              ///
              /// PRECIPITATION
              ///
              Expanded(
                child: AdditionalValueWidget(
                  icon: PromajaIcons.precipitation,
                  value: precipitationText,
                  description: 'precipitation'.tr(),
                ),
              ),

              Container(
                height: 40,
                width: 0.5,
                color: PromajaColors.white.withValues(alpha: 0.4),
              ),

              ///
              /// FEELS LIKE
              ///
              Expanded(
                child: AdditionalValueWidget(
                  icon: PromajaIcons.feelsLike,
                  value: '${feelsLikeTemperature.round()}°',
                  description: 'feelsLike'.tr(),
                ),
              ),
            ],
          ),
        ),
      );
}
