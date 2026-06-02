import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/typedefs.dart';
import '../../../../models/location/location.dart';
import '../../../../services/api_service.dart';
import '../../../../util/error.dart';
import 'list_card_error.dart';
import 'list_card_loading.dart';
import 'list_card_success.dart';

class ListCardWidget extends WatchingWidget {
  final Location originalLocation;
  final Function() onTap;
  final Function(CompletionHandler handler) onTapDelete;
  final bool showCelsius;
  final int index;

  const ListCardWidget({
    required this.originalLocation,
    required this.onTap,
    required this.onTapDelete,
    required this.showCelsius,
    required this.index,
    required super.key,
  });

  @override
  Widget build(BuildContext context) {
    final futureSnapshot = watchFuture<APIService, CurrentWeatherResult>(
      (api) => api.getCachedCurrentWeather(
        query: '${originalLocation.lat},${originalLocation.lon}',
      ),
      initialValue: (
        response: null,
        error: null,
        genericError: null,
      ),
    );

    return SwipeActionCell(
      key: key!,
      openAnimationCurve: Curves.easeIn,
      closeAnimationCurve: Curves.easeIn,
      trailingActions: [
        SwipeAction(
          onTap: onTapDelete,
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
      child: Animate(
        key: ValueKey(index),
        delay: (PromajaDurations.listInterval.inMilliseconds * index).milliseconds,
        effects: [
          FadeEffect(
            curve: Curves.easeIn,
            duration: PromajaDurations.fadeAnimation,
          ),
        ],
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Builder(
            builder: (context) {
              ///
              /// LOADING
              ///
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return ListCardLoading(
                  originalLocationName: originalLocation.name,
                  isPhoneLocation: originalLocation.isPhoneLocation ?? false,
                  onTap: onTap,
                );
              }

              ///
              /// ERROR
              ///
              if (futureSnapshot.hasError) {
                final error = futureSnapshot.error;

                return ListCardError(
                  originalLocation: originalLocation,
                  isPhoneLocation: originalLocation.isPhoneLocation ?? false,
                  error: '$error',
                  onTap: () {},
                );
              }

              ///
              /// SUCCESS
              ///
              final data = futureSnapshot.data;

              ///
              /// DATA SUCCESSFULLY FETCHED
              ///
              if (data?.response != null && data?.error == null) {
                final currentWeather = data!.response!.current;
                final fetchedLocation = data.response!.location;

                return ListCardSuccess(
                  location: originalLocation,
                  isPhoneLocation: originalLocation.isPhoneLocation ?? false,
                  currentWeather: currentWeather,
                  onTap: onTap,
                  showCelsius: showCelsius,
                );
              }

              ///
              /// ERROR WHILE FETCHING
              ///
              return ListCardError(
                originalLocation: originalLocation,
                isPhoneLocation: originalLocation.isPhoneLocation ?? false,
                error: getErrorDescription(
                  errorCode: data?.error?.error.code ?? 0,
                ),
                onTap: onTap,
              );
            },
          ),
        ),
      ),
    );
  }
}
