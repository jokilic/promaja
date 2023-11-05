import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/icons.dart';
import 'additional_value_widget.dart';

class AdditionalPCV extends StatelessWidget {
  final double pressure;
  final int cloud;
  final double visibility;

  const AdditionalPCV({
    required this.pressure,
    required this.cloud,
    required this.visibility,
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
            /// PRESSURE
            ///
            Expanded(
              child: AdditionalValueWidget(
                icon: PromajaIcons.pressure,
                value: '${pressure.round()} hPa',
                description: 'pressure'.tr(),
              ),
            ),

            Container(
              height: 40,
              width: 0.5,
              color: PromajaColors.white.withOpacity(0.4),
            ),

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
          ],
        ),
      );
}
