import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/icons.dart';
import '../../../constants/text_styles.dart';

class SettingsPopupMenuListTile extends StatelessWidget {
  final Function(TapDownDetails details) onTapDown;
  final Function(TapUpDetails details) onTapUp;
  final String activeValue;
  final String subtitle;

  const SettingsPopupMenuListTile({
    required this.onTapDown,
    required this.onTapUp,
    required this.activeValue,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          splashColor: PromajaColors.white.withOpacity(0.15),
          contentPadding: const EdgeInsets.all(8),
          title: Text(
            activeValue,
            style: PromajaTextStyles.settingsSubtitle,
          ),
          subtitle: Text(
            subtitle,
            style: PromajaTextStyles.settingsText,
          ),
          trailing: Transform.rotate(
            angle: 90 * pi / 180,
            child: Image.asset(
              PromajaIcons.arrow,
              color: PromajaColors.white,
              height: 28,
              width: 28,
            ),
          ),
        ),
      );
}
