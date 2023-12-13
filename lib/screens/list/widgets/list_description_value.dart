import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';

class ListDescriptionValue extends StatelessWidget {
  final String icon;
  final String description;

  const ListDescriptionValue({
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 24,
              width: 24,
              color: PromajaColors.white,
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                description,
                style: PromajaTextStyles.settingsText,
              ),
            ),
          ],
        ),
      );
}
