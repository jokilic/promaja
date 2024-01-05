import 'package:easy_localization/easy_localization.dart';
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'notificationDialog1'.tr(),
              style: PromajaTextStyles.settingsDialog,
            ),
            const SizedBox(height: 16),
            Text(
              'notificationDialog2'.tr(),
              style: PromajaTextStyles.settingsDialog,
            ),
            const SizedBox(height: 16),
            Text(
              'notificationDialog3'.tr(),
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
              'okay'.tr().toUpperCase(),
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
