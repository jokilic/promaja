import 'package:flutter/material.dart';

import '../../constants/text_styles.dart';
import '../../widgets/promaja_navigation_bar.dart';

class TestingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: PromajaNavigationBar(),
        body: const SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello, hello',
                  style: PromajaTextStyles.testingTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome to Testing screen',
                  style: PromajaTextStyles.testingTitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
}
