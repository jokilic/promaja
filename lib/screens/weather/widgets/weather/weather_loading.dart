import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/location/location.dart';
import '../../../../util/color.dart';

class WeatherLoading extends StatelessWidget {
  final Location location;
  final bool isWeatherSummary;

  const WeatherLoading({
    required this.location,
    required this.isWeatherSummary,
  });

  @override
  Widget build(BuildContext context) => isWeatherSummary
      ? ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  lightenColor(PromajaColors.black),
                  darkenColor(PromajaColors.indigo),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: SizedBox(
              // TODO
              height: MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).bottom,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  // TODO
                  SizedBox(
                    height: MediaQuery.paddingOf(context).top + 32,
                  ),

                  ///
                  /// TITLE & LOCATION
                  ///
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'weatherSummary'.tr(),
                      style: PromajaTextStyles.settingsSubtitle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${location.name}, ${location.country}',
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: PromajaTextStyles.settingsTitle,
                    ),
                  ),

                  ///
                  /// DIVIDER
                  ///
                  const SizedBox(height: 16),
                  const Divider(
                    indent: 120,
                    endIndent: 120,
                    color: PromajaColors.white,
                  ),

                  ///
                  /// SUMMARY FORECASTS
                  ///
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (_, __) => Animate(
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
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 28,
                                  width: 144,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: PromajaColors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 16,
                                  width: 104,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: PromajaColors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: PromajaColors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: PromajaColors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PromajaColors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      : Container(
          width: MediaQuery.sizeOf(context).width,
          // TODO
          margin: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).top + 64),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
            gradient: LinearGradient(
              colors: [
                lightenColor(Colors.amberAccent),
                darkenColor(Colors.amberAccent),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(10, (index) => const SizedBox.shrink()),

              ///
              /// LAST UPDATED & LOCATION
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
                child: Column(
                  children: [
                    Container(
                      height: 16,
                      width: 104,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: PromajaColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 32,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: PromajaColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),

              ...List.generate(5, (index) => const SizedBox.shrink()),

              ///
              /// WEATHER ICON
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
                  height: 176,
                  width: 176,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PromajaColors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),

              ...List.generate(5, (index) => const SizedBox.shrink()),

              ///
              /// TEMPERATURE & WEATHER
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
                child: Column(
                  children: [
                    Container(
                      height: 104,
                      width: 144,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: PromajaColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 32,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: PromajaColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),

              ///
              /// ADDITIONAL INFO
              ///
              Container(
                height: 144,
                color: Colors.transparent,
                margin: const EdgeInsets.all(8),
              ),
            ],
          ),
        );
}
