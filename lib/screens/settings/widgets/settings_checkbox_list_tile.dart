import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';

class SettingsCheckboxListTile extends StatelessWidget {
  final bool value;
  final Function() onTap;
  final String title;
  final String subtitle;

  const SettingsCheckboxListTile({
    required this.value,
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
        trailing: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: PromajaColors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(4),
            color: value ? PromajaColors.white : null,
          ),
          child: Icon(
            // TODO: Check from FlatIcons
            Icons.check_rounded,
            size: 24,
            color: value ? PromajaColors.black : Colors.transparent,
          ),
        ),
      );
}
