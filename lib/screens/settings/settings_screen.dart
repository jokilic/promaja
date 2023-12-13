import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/custom_color/custom_color.dart';
import '../../services/hive_service.dart';
import '../../util/weather.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'widgets/settings_card_widget.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> openColorPicker({
    required CustomColor customColor,
    required BuildContext context,
  }) async {
    var color = customColor.color;

    await showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: PromajaColors.white,
      builder: (context) => ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),

          ///
          /// COLOR PICKER
          ///
          ColorPicker(
            pickerColor: color,
            onColorChanged: (newColor) => color = newColor,
            enableAlpha: false,
            hexInputBar: true,
            labelTypes: const [],
            pickerAreaBorderRadius: BorderRadius.circular(8),
            pickerAreaHeightPercent: 0.85,
          ),

          ///
          /// BUTTONS
          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///
              /// REVERT
              ///
              ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(hiveProvider.notifier).deleteCustomColorFromBox(
                        customColor: customColor,
                      );
                  Navigator.of(context).pop();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: PromajaColors.black,
                  backgroundColor: Colors.transparent,
                ),
                icon: const Icon(Icons.undo_rounded),
                label: Text('revert'.tr()),
              ),

              ///
              /// SAVE
              ///
              ElevatedButton.icon(
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
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: PromajaColors.black,
                  backgroundColor: Colors.transparent,
                ),
                icon: const Icon(Icons.done_rounded),
                label: Text('save'.tr()),
              ),
            ],
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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 16),

            ///
            /// CARD COLORS TITLE
            ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'cardColors'.tr(),
                style: PromajaTextStyles.settingsTitle,
              ),
            ),
            const SizedBox(height: 16),

            ///
            /// CARD COLORS DESCRIPTION
            ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'cardColorsDescription1'.tr(),
                style: PromajaTextStyles.settingsText,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'cardColorsDescription2'.tr(),
                style: PromajaTextStyles.settingsText,
              ),
            ),

            const SizedBox(height: 32),

            ///
            /// DAY TITLE
            ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'day'.tr(),
                style: PromajaTextStyles.settingsSubtitle,
              ),
            ),
            const SizedBox(height: 8),

            ///
            /// DAY VALUES
            ///
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
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

                return SettingsCardWidget(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'night'.tr(),
                style: PromajaTextStyles.settingsSubtitle,
              ),
            ),
            const SizedBox(height: 8),

            ///
            /// NIGHT VALUES
            ///
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
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

                return SettingsCardWidget(
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
