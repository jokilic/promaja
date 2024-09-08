import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/colors.dart';
import '../../../constants/durations.dart';
import '../../../constants/text_styles.dart';
import '../../../models/location/location.dart';
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'locationDeleted'.tr(
            args: [location.name, location.country],
          ),
          style: PromajaTextStyles.snackbar,
        ),
        backgroundColor: PromajaColors.black,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: PromajaColors.white,
            width: 2,
          ),
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
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex--;
                }

                ref.read(hiveProvider.notifier).reorderLocations(oldIndex, newIndex);
              },

              padding: const EdgeInsets.symmetric(vertical: 8),
              physics: const BouncingScrollPhysics(),
              scrollController: ref.watch(addLocationProvider.notifier).scrollController,
              itemCount: locations.length + 1, // + 1 for the empty item at the end
              itemBuilder: (context, index) {
                if (index == locations.length) {
                  return SizedBox.shrink(key: UniqueKey());
                }

                final location = locations[index];
                final locationKey = ValueKey(location);

                return Animate(
                  key: locationKey,
                  delay: (PromajaDurations.listInterval.inMilliseconds * index).milliseconds,
                  effects: [
                    FadeEffect(
                      curve: Curves.easeIn,
                      duration: PromajaDurations.fadeAnimation,
                    ),
                  ],
                  child: ListCardWidget(
                    key: locationKey,
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
              },
            ),
          ),
        ],
      );
}
