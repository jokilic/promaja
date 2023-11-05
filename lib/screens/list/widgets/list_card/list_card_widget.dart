import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

import '../../../../constants/colors.dart';
import '../../../../models/location/location.dart';
import '../../../cards/cards_notifiers.dart';
import 'list_card_error.dart';
import 'list_card_loading.dart';
import 'list_card_success.dart';

class ListCardWidget extends ConsumerWidget {
  final Location location;
  final int index;
  final Function() onTap;
  final Function() onTapDelete;

  const ListCardWidget({
    required this.location,
    required this.index,
    required this.onTap,
    required this.onTapDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SwipeActionCell(
        key: ValueKey(location),
        openAnimationCurve: Curves.easeIn,
        closeAnimationCurve: Curves.easeIn,
        trailingActions: [
          SwipeAction(
            onTap: (_) => onTapDelete(),
            color: Colors.transparent,
            backgroundRadius: 100,
            content: Container(
              height: 80,
              width: double.infinity,
              margin: const EdgeInsets.only(
                left: 8,
                right: 16,
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: PromajaColors.white,
                size: 40,
              ),
            ),
          ),
        ],
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ref.watch(getCurrentWeatherProvider(location)).when(
                data: (data) {
                  ///
                  /// DATA SUCCESSFULLY FETCHED
                  ///
                  if (data.response != null && data.error == null) {
                    final currentWeather = data.response!.current;
                    final fetchedLocation = data.response!.location;

                    return ListCardSuccess(
                      locationName: fetchedLocation.name,
                      currentWeather: currentWeather,
                      onTap: onTap,
                    );
                  }

                  ///
                  /// ERROR WHILE FETCHING
                  ///
                  return ListCardError(
                    locationName: location.name,
                    error: data.error ?? 'weirdErrorHappened'.tr(),
                    onTap: onTap,
                  );
                },

                ///
                /// ERROR STATE
                ///
                error: (error, _) => ListCardError(
                  locationName: location.name,
                  error: '$error',
                  onTap: () {},
                ),

                ///
                /// LOADING STATE
                ///
                loading: () => ListCardLoading(
                  locationName: location.name,
                  onTap: onTap,
                ),
              ),
        ),
      );
}
