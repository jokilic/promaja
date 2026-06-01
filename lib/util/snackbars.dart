import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

/// Shows an error message while replacing any currently visible snackbar
void showErrorSnackbar({
  required BuildContext context,
  required String errorText,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          errorText,
          style: PromajaTextStyles.snackbar,
        ),
        backgroundColor: PromajaColors.black,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: PromajaColors.white,
            width: 2,
          ),
        ),
      ),
    );
}
