import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';

class NotificationDialog extends StatelessWidget {
  final Function() onPressed;

  const NotificationDialog({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        elevation: 0,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'When Promaja is not running, notifications get triggered when the system decides.',
              style: PromajaTextStyles.settingsDialog,
            ),
            SizedBox(height: 16),
            Text(
              'This is a system limitation which I cannot work around.',
              style: PromajaTextStyles.settingsDialog,
            ),
            SizedBox(height: 16),
            Text(
              "I can't guarantee it, but I hope you have a stable notification experience.",
              style: PromajaTextStyles.settingsDialog,
            ),
          ],
        ),
        contentTextStyle: PromajaTextStyles.settingsDialog,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: PromajaColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              'Okay'.toUpperCase(),
              style: PromajaTextStyles.settingsDialogButton,
            ),
          ),
        ],
        contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 8),
        actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        backgroundColor: PromajaColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: PromajaColors.white,
            width: 2,
          ),
        ),
      );
}
