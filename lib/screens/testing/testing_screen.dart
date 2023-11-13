import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/text_styles.dart';
import '../../models/custom_color/custom_color.dart';
import '../../services/hive_service.dart';
import '../../util/weather.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'widgets/testing_card_widget.dart';

class TestingScreen extends ConsumerWidget {
  void openColorPicker() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CustomColor?> customColors = ref.watch(hiveProvider.notifier).getCustomColorsFromBox();

    return Scaffold(
      bottomNavigationBar: PromajaNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            ///
            /// DAY TITLE
            ///
            const Text(
              'Day',
              style: PromajaTextStyles.testingTitle,
            ),

            ///
            /// DAY VALUES
            ///
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: weatherCodes.length,
                itemBuilder: (_, index) {
                  final weatherCode = weatherCodes[index];

                  final customColor = customColors.firstWhere(
                    (customColor) => customColor?.code == weatherCode && (customColor?.isDay ?? false),
                    orElse: () => null,
                  );

                  final color = customColor?.color ??
                      getWeatherColor(
                        code: weatherCode,
                        isDay: true,
                      );
                  final icon = getWeatherIcon(
                    code: weatherCode,
                    isDay: true,
                  );
                  final description = getWeatherDescription(
                    code: weatherCode,
                    isDay: true,
                  );

                  return TestingCardWidget(
                    backgroundColor: color,
                    onTap: openColorPicker,
                    weatherIcon: icon,
                    description: description,
                  );
                },
              ),
            ),

            ///
            /// NIGHT TITLE
            ///
            const Text(
              'Night',
              style: PromajaTextStyles.testingTitle,
            ),

            ///
            /// NIGHT VALUES
            ///
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: weatherCodes.length,
                itemBuilder: (_, index) {
                  final weatherCode = weatherCodes[index];

                  final customColor = customColors.firstWhere(
                    (customColor) => customColor?.code == weatherCode && !(customColor?.isDay ?? true),
                    orElse: () => null,
                  );

                  final color = customColor?.color ??
                      getWeatherColor(
                        code: weatherCode,
                        isDay: false,
                      );
                  final icon = getWeatherIcon(
                    code: weatherCode,
                    isDay: false,
                  );
                  final description = getWeatherDescription(
                    code: weatherCode,
                    isDay: true,
                  );

                  return TestingCardWidget(
                    backgroundColor: color,
                    onTap: () {},
                    weatherIcon: icon,
                    description: description,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
