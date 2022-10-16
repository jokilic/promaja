// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../constants/colors.dart';

// ///
// /// Class which will trigger various snackbars
// /// Can be used throughout the app with `PromajaSnackbars.showSomeSnackbar`
// ///

// class PromajaSnackbars {
//   /// Snackbar shown if some success happens
//   static void showSuccessSnackbar({
//     required BuildContext context,
//     required String message,
//     Color backgroundColor = PromajaColors.blue,
//     IconData icon = Icons.check,
//   }) =>
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: ,
//           backgroundColor: backgroundColor,
//           icon: Icon(
//             icon,
//             color: PromajaColors.blue,
//           ),
//           message: message,
//           margin: EdgeInsets.all(32.r),
//           padding: EdgeInsets.all(24.r),
//           borderRadius: 16.r,
//         ),
//       );

//   /// Snackbar shown if some error happens
//   static void showErrorSnackbar({
//     required BuildContext context,
//     required String message,
//     Color backgroundColor = PromajaColors.blue,
//     IconData icon = Icons.close,
//   }) =>
//       Get.rawSnackbar(
//         backgroundColor: backgroundColor,
//         icon: Icon(
//           icon,
//           color: PromajaColors.blue,
//         ),
//         message: message,
//         margin: EdgeInsets.all(32.r),
//         padding: EdgeInsets.all(24.r),
//         borderRadius: 16.r,
//       );
// }
