import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/icons.dart';
import '../../../constants/text_styles.dart';

class SettingsListTile extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String subtitle;

  const SettingsListTile({
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        splashColor: PromajaColors.white.withOpacity(0.15),
        onTap: onTap,
        contentPadding: const EdgeInsets.all(8),
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
            PromajaIcons.arrow,
            color: PromajaColors.white,
            height: 28,
            width: 28,
          ),
        ),
      );
}
