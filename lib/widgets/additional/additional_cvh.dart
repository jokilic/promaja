import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/icons.dart';
import 'additional_value_widget.dart';

class AdditionalCVH extends StatelessWidget {
  final int cloud;
  final double visibility;
  final int humidity;

  const AdditionalCVH({
    required this.cloud,
    required this.visibility,
    required this.humidity,
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
          children: [
            ///
            /// CLOUD
            ///
            Expanded(
              child: AdditionalValueWidget(
                icon: PromajaIcons.cloudiness,
                value: '$cloud%',
                description: 'cloud'.tr(),
              ),
            ),

            Container(
              height: 40,
              width: 0.5,
              color: PromajaColors.white.withOpacity(0.4),
            ),

            ///
            /// VISIBILITY
            ///
            Expanded(
              child: AdditionalValueWidget(
                icon: PromajaIcons.visibility,
                value: '${visibility.round()} km',
                description: 'visibility'.tr(),
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
          ],
        ),
      );
}
