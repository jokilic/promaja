import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';

class LoggingListTile extends StatelessWidget {
  final Function() onTap;
  final String text;
  final String time;
  final IconData icon;
  final bool isError;

  const LoggingListTile({
    required this.onTap,
    required this.text,
    required this.time,
    required this.icon,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        splashColor: PromajaColors.white.withOpacity(0.15),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isError ? PromajaColors.red : null,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: PromajaColors.white,
            size: 26,
          ),
        ),
        title: Text(
          text,
          style: PromajaTextStyles.settingsText,
        ),
        trailing: Text(
          time,
          style: PromajaTextStyles.settingsText,
        ),
      );
}
