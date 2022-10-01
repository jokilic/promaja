import 'package:flutter/material.dart';
import 'package:get/get.dart';

///
/// Widget which gets wrapped around any content that needs to be responsive
/// Has parameters for `mobile`, `tablet` and `desktop`
///

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static const mobileBreakpoint = 850;
  static const desktopBreakpoint = 1100;

  static final isMobile = Get.width < mobileBreakpoint;
  static final isTablet = Get.width < desktopBreakpoint && Get.width >= mobileBreakpoint;
  static final isDesktop = Get.width >= desktopBreakpoint;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= desktopBreakpoint) {
            return desktop ?? tablet ?? mobile;
          } else if (constraints.maxWidth >= mobileBreakpoint) {
            return tablet ?? mobile;
          } else {
            return mobile;
          }
        },
      );
}
