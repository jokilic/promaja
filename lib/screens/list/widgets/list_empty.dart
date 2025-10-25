import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/colors.dart';
import '../../../constants/durations.dart';
import '../../../constants/icons.dart';
import '../../../constants/text_styles.dart';
import 'add_location/add_location_widget.dart';
import 'list_description_value.dart';

class ListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ///
      /// ADD LOCATION & ARROW TEXT
      ///
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: AddLocationWidget(),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 104,
            child: Column(
              children: [
                const Icon(
                  Icons.arrow_upward_rounded,
                  size: 32,
                  color: PromajaColors.white,
                ),
                Text(
                  'addLocation'.tr(),
                  style: PromajaTextStyles.settingsText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),

      ///
      /// PROMAJA ICON
      ///
      Animate(
        onPlay: (controller) => controller.loop(reverse: true),
        delay: PromajaDurations.weatherIconScaleDelay,
        effects: [
          ScaleEffect(
            curve: Curves.easeIn,
            end: const Offset(1.5, 1.5),
            duration: PromajaDurations.weatherIconScalAnimation,
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

      ///
      /// NAVIGATION DESCRIPTION
      ///
      Column(
        children: [
          ListDescriptionValue(
            icon: PromajaIcons.globe,
            description: 'navigationDescriptionCurrent'.tr(),
          ),
          ListDescriptionValue(
            icon: PromajaIcons.temperature,
            description: 'navigationDescriptionWeather'.tr(),
          ),
          ListDescriptionValue(
            icon: PromajaIcons.map,
            description: 'navigationDescriptionMap'.tr(),
          ),
          ListDescriptionValue(
            icon: PromajaIcons.list,
            description: 'navigationDescriptionList'.tr(),
          ),
          ListDescriptionValue(
            icon: PromajaIcons.settings,
            description: 'navigationDescriptionSettings'.tr(),
          ),
        ],
      ),
    ],
  );
}
