import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';

class LoggingListTile extends StatelessWidget {
  final Function() onTap;
  final String group;
  final String text;
  final String time;

  final bool isError;

  const LoggingListTile({
    required this.onTap,
    required this.group,
    required this.text,
    required this.time,
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
          horizontal: 20,
          vertical: 8,
        ),
        leading: FittedBox(
          child: SizedBox(
            width: 40,
            child: FittedBox(
              child: Text(
                group.substring(0, 3).toUpperCase(),
                style: PromajaTextStyles.settingsAbbreviation.copyWith(
                  color: isError ? PromajaColors.red : null,
                ),
              ),
            ),
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
