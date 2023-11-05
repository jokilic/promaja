import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/icons.dart';
import '../../../constants/text_styles.dart';
import 'add_location/add_location_widget.dart';

class ListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: AddLocationWidget(),
          ),
          Column(
            children: [
              Image.asset(
                PromajaIcons.icon,
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'startUsing1'.tr()),
                      TextSpan(
                        text: 'startUsing2'.tr(),
                        style: PromajaTextStyles.noLocationsPromaja,
                      ),
                      TextSpan(text: 'startUsing3'.tr()),
                    ],
                  ),
                  style: PromajaTextStyles.noLocations,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox.shrink()
        ],
      );
}
