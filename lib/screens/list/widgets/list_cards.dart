import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/colors.dart';
import '../../../constants/durations.dart';
import '../../../constants/text_styles.dart';
import '../../../models/location/location.dart';
import '../../../models/promaja_log/promaja_log_level.dart';
import '../../../services/hive_service.dart';
import '../../../widgets/promaja_navigation_bar.dart';
import '../notifiers/add_location_notifier.dart';
import 'add_location/add_location_widget.dart';
import 'list_card/list_card_widget.dart';

class ListCards extends ConsumerWidget {
  final List<Location> locations;
  final bool showCelsius;

  const ListCards({
    required this.locations,
    required this.showCelsius,
  });

  Future<void> deleteLocation({
    required WidgetRef ref,
    required BuildContext context,
    required Location location,
    required int index,
  }) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    await ref.read(hiveProvider.notifier).deleteLocationFromBox(index: index);

    ref.read(hiveProvider.notifier).logPromajaEvent(
          text: 'Delete -> ${location.name}, ${location.country}',
          logGroup: PromajaLogGroup.list,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'locationDeleted'.tr(
            args: [location.name, location.country],
          ),
          style: PromajaTextStyles.snackbar,
        ),
        backgroundColor: PromajaColors.indigo,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> openWeatherScreen({required WidgetRef ref, required int index}) async {
    await ref.read(hiveProvider.notifier).addActiveLocationIndexToBox(index: index);
    await ref.read(navigationBarIndexProvider.notifier).changeNavigationBarIndex(NavigationBarItems.weather.index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          ///
          /// ADD NEW LOCATION
          ///
          Animate(
            key: const ValueKey('add_location'),
            delay: (PromajaDurations.listInterval.inMilliseconds * locations.length).milliseconds,
            effects: [
              FadeEffect(
                curve: Curves.easeIn,
                duration: PromajaDurations.fadeAnimation,
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: AddLocationWidget(),
            ),
          ),
          const SizedBox(height: 8),

          ///
          /// LIST OF LOCATIONS
          ///
          Flexible(
            child: AnimatedReorderableListView(
              onReorder: ref.read(hiveProvider.notifier).reorderLocations,
              padding: const EdgeInsets.symmetric(vertical: 8),
              physics: const BouncingScrollPhysics(),
              controller: ref.watch(addLocationProvider.notifier).scrollController,
              insertDuration: PromajaDurations.fadeAnimation,
              removeDuration: PromajaDurations.fadeAnimation,
              enterTransition: [
                FlipInX(
                  duration: PromajaDurations.fadeAnimation,
                  curve: Curves.easeIn,
                ),
              ],
              exitTransition: [
                FlipInX(
                  duration: PromajaDurations.fadeAnimation,
                  curve: Curves.easeIn,
                ),
              ],
              items: [
                ...locations,
                Location(
                  name: '',
                  region: '',
                  country: '',
                  lat: 0,
                  lon: 0,
                ),
              ],
              itemBuilder: (_, index) {
                final location = locations.elementAtOrNull(index);

                if (location != null) {
                  return Animate(
                    key: ValueKey(location),
                    delay: (PromajaDurations.listInterval.inMilliseconds * index).milliseconds,
                    effects: [
                      FadeEffect(
                        curve: Curves.easeIn,
                        duration: PromajaDurations.fadeAnimation,
                      ),
                    ],
                    child: ListCardWidget(
                      location: location,
                      showCelsius: showCelsius,
                      onTap: () => openWeatherScreen(
                        index: index,
                        ref: ref,
                      ),
                      onTapDelete: (handler) {
                        handler(false);

                        deleteLocation(
                          ref: ref,
                          context: context,
                          location: location,
                          index: index,
                        );
                      },
                    ),
                  );
                }

                return SizedBox.shrink(
                  key: UniqueKey(),
                );
              },
            ),
          ),
        ],
      );
}
