import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/icons.dart';
import 'additional_value_widget.dart';

class AdditionalTU extends StatelessWidget {
  final double minTemp;
  final double maxTemp;
  final double uv;

  const AdditionalTU({
    required this.minTemp,
    required this.maxTemp,
    required this.uv,
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
            /// MIN/MAX TEMPERATURE
            ///
            Expanded(
              child: AdditionalValueWidget(
                icon: PromajaIcons.tempMaxMin,
                value: '${maxTemp.round()}° / ${minTemp.round()}°',
                description: 'Max / Min',
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
                description: 'UV index',
              ),
            ),

            Container(
              height: 40,
              width: 0.5,
              color: PromajaColors.white.withOpacity(0.4),
            ),

            ///
            /// WHAT HERE?
            ///
            const Expanded(
              child: AdditionalValueWidget(
                icon: PromajaIcons.dontKnow,
                value: '---',
                description: 'What here?',
              ),
            ),
          ],
        ),
      );
}
