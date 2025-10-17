import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/icons.dart';
import '../constants/text_styles.dart';
import '../util/color.dart';

class PromajaErrorWidget extends StatelessWidget {
  final String error;

  const PromajaErrorWidget({
    required this.error,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
    body: Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).top + 64),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
        gradient: LinearGradient(
          colors: [
            lightenColor(PromajaColors.red),
            darkenColor(PromajaColors.red),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.shrink(),

          ///
          /// DATE & LOCATION
          ///
          Column(
            children: [
              const SizedBox(height: 24),
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: PromajaTextStyles.weatherCardLastUpdated,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              const Text(
                'Promaja',
                style: PromajaTextStyles.currentLocation,
                textAlign: TextAlign.center,
              ),
            ],
          ),

          ///
          /// ERROR ICON
          ///
          Transform.scale(
            scale: 1.2,
            child: Image.asset(
              PromajaIcons.tornado,
              height: 176,
              width: 176,
            ),
          ),

          ///
          /// ERROR
          ///
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  'error'.tr(),
                  style: PromajaTextStyles.errorFetching,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    error,
                    style: PromajaTextStyles.currentWeather,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox.shrink(),
        ],
      ),
    ),
  );
}
