import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

///
/// Class which will trigger various snackbars
/// Can be used throughout the app with `MySnackbars.showSomeSnackbar`
///

class MySnackbars {
  /// Snackbar shown if some success happens
  static void showSuccessSnackbar({
    required String message,
    Color backgroundColor = PromajaColors.blue,
    IconData icon = Icons.check,
  }) =>
      Get.rawSnackbar(
        backgroundColor: backgroundColor,
        icon: Icon(
          icon,
          color: PromajaColors.blue,
        ),
        message: message,
        margin: EdgeInsets.all(32.r),
        padding: EdgeInsets.all(24.r),
        borderRadius: 16.r,
      );

  /// Snackbar shown if some error happens
  static void showErrorSnackbar({
    required String message,
    Color backgroundColor = PromajaColors.blue,
    IconData icon = Icons.close,
  }) =>
      Get.rawSnackbar(
        backgroundColor: backgroundColor,
        icon: Icon(
          icon,
          color: PromajaColors.blue,
        ),
        message: message,
        margin: EdgeInsets.all(32.r),
        padding: EdgeInsets.all(24.r),
        borderRadius: 16.r,
      );
}
