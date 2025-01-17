import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/icons.dart';

class PromajaBackButton extends StatelessWidget {
  const PromajaBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        style: IconButton.styleFrom(
          highlightColor: PromajaColors.white.withValues(alpha: 0.15),
          shape: const CircleBorder(),
        ),
        splashColor: PromajaColors.white.withValues(alpha: 0.15),
        onPressed: Navigator.of(context).pop,
        icon: Transform.rotate(
          angle: 180 * pi / 180,
          child: Image.asset(
            PromajaIcons.arrow,
            color: PromajaColors.white,
            height: 32,
            width: 32,
          ),
        ),
      );
}
