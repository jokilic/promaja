import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/durations.dart';
import '../../../constants/icons.dart';
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
        trailing: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
              color: PromajaColors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: AnimatedSwitcher(
            duration: PromajaDurations.checkAnimation,
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeIn,
            child: Image.asset(
              key: ValueKey(value),
              PromajaIcons.check,
              color: value ? null : Colors.transparent,
              height: 20,
              width: 20,
            ),
          ),
        ),
      );
}
