import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/icons.dart';
import 'additional_value_widget.dart';

class AdditionalPUG extends StatelessWidget {
  final double pressure;
  final double uv;
  final double gust;

  const AdditionalPUG({
    required this.pressure,
    required this.uv,
    required this.gust,
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
            /// UV
            ///
            Expanded(
              child: AdditionalValueWidget(
                icon: PromajaIcons.uv,
                value: '${uv.round()}',
                description: 'uvIndex'.tr(),
              ),
            ),

            Container(
              height: 40,
              width: 0.5,
              color: PromajaColors.white.withOpacity(0.4),
            ),

            ///
            /// GUST
            ///
            Expanded(
              child: AdditionalValueWidget(
                icon: PromajaIcons.gust,
                value: '${gust.round()} km/h',
                description: 'gust'.tr(),
              ),
            ),
          ],
        ),
      );
}
