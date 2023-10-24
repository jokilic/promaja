import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../constants/icons.dart';
import '../../../constants/text_styles.dart';
import 'add_location/add_location_result.dart';

class ListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AnimationLimiter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 400),
            childAnimationBuilder: (widget) => FadeInAnimation(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
              child: widget,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: AddLocationResult(),
              ),
              Column(
                children: [
                  Image.asset(
                    PromajaIcons.icon,
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Start using '),
                          TextSpan(
                            text: 'Promaja',
                            style: PromajaTextStyles.noLocationsPromaja,
                          ),
                          TextSpan(text: ' by adding some places...'),
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
          ),
        ),
      );
}
