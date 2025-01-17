import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';

class SettingsListTile extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String subtitle;
  final String icon;

  const SettingsListTile({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        splashColor: PromajaColors.white.withValues(alpha: 0.15),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        title: Text(
          title,
          style: PromajaTextStyles.settingsSubtitle,
        ),
        subtitle: Text(
          subtitle,
          style: PromajaTextStyles.settingsText,
        ),
        trailing: Transform.rotate(
          angle: -45 * pi / 180,
          child: Image.asset(
            icon,
            color: PromajaColors.white,
            height: 28,
            width: 28,
          ),
        ),
      );
}
