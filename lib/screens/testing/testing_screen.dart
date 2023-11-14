import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/text_styles.dart';
import '../../models/custom_color/custom_color.dart';
import '../../services/hive_service.dart';
import '../../util/weather.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'widgets/testing_card_widget.dart';

class TestingScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestingScreenState();
}

class _TestingScreenState extends ConsumerState<TestingScreen> {
  /// Opens color picker
  Future<void> openColorPicker({
    required CustomColor customColor,
    required BuildContext context,
  }) async {
    var color = customColor.color;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Choose a color'),
        content: Material(
          color: Colors.transparent,
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (newColor) => color = newColor,
            enableAlpha: false,
            hexInputBar: true,
            labelTypes: const [],
            pickerAreaBorderRadius: BorderRadius.circular(8),
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(hiveProvider.notifier).addCustomColorToBox(
                    customColor: CustomColor(
                      code: customColor.code,
                      isDay: customColor.isDay,
                      color: color,
                    ),
                  );
              Navigator.of(context).pop();
              setState(() {});
            },
            icon: const Icon(
              Icons.done_rounded,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = ref.watch(hiveProvider.notifier).getCustomColorsFromBox();

    return Scaffold(
      bottomNavigationBar: PromajaNavigationBar(),
      body: SafeArea(
        child: ListView(
          children: [
            ///
            /// DAY TITLE
            ///
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Day',
                style: PromajaTextStyles.testingTitle,
              ),
            ),
            const SizedBox(height: 8),

            ///
            /// DAY VALUES
            ///
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: weatherCodes.length,
              itemBuilder: (_, index) {
                final weatherCode = weatherCodes[index];

                final customColor = customColors.firstWhere(
                  (customColor) => customColor.code == weatherCode && customColor.isDay,
                  orElse: () => CustomColor(
                    code: weatherCode,
                    isDay: true,
                    color: getWeatherColor(
                      code: weatherCode,
                      isDay: true,
                    ),
                  ),
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
                  onTap: () => openColorPicker(
                    customColor: customColor,
                    context: context,
                  ),
                  backgroundColor: customColor.color,
                  weatherIcon: icon,
                  description: description,
                );
              },
            ),
            const SizedBox(height: 32),

            ///
            /// NIGHT TITLE
            ///
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Night',
                style: PromajaTextStyles.testingTitle,
              ),
            ),
            const SizedBox(height: 8),

            ///
            /// NIGHT VALUES
            ///
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: weatherCodes.length,
              itemBuilder: (_, index) {
                final weatherCode = weatherCodes[index];

                final customColor = customColors.firstWhere(
                  (customColor) => customColor.code == weatherCode && !customColor.isDay,
                  orElse: () => CustomColor(
                    code: weatherCode,
                    isDay: false,
                    color: getWeatherColor(
                      code: weatherCode,
                      isDay: false,
                    ),
                  ),
                );

                final icon = getWeatherIcon(
                  code: weatherCode,
                  isDay: false,
                );

                final description = getWeatherDescription(
                  code: weatherCode,
                  isDay: false,
                );

                return TestingCardWidget(
                  onTap: () => openColorPicker(
                    customColor: customColor,
                    context: context,
                  ),
                  backgroundColor: customColor.color,
                  weatherIcon: icon,
                  description: description,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
