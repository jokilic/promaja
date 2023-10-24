import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class AdditionalValueWidget extends StatelessWidget {
  final String icon;
  final String value;
  final String description;
  final int? rotation;

  const AdditionalValueWidget({
    required this.icon,
    required this.value,
    required this.description,
    this.rotation,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///
          /// ICON
          ///
          Transform.rotate(
            angle: rotation != null ? pi * (rotation! - 90) / 180 : 0,
            child: Image.asset(
              icon,
              height: 22,
              width: 22,
              color: PromajaColors.white,
            ),
          ),

          const SizedBox(height: 8),

          ///
          /// VALUE
          ///
          Text(
            value,
            style: PromajaTextStyles.currentListData,
          ),

          const SizedBox(height: 4),

          ///
          /// DESCRIPTION
          ///
          Text(
            description,
            style: PromajaTextStyles.currentListDescription,
          ),
        ],
      );
}
