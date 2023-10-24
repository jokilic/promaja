import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';
import '../../../models/location/location.dart';
import '../../../services/hive_service.dart';
import '../../weather/weather_screen.dart';
import '../notifiers/add_location_notifier.dart';
import 'add_location/add_location_result.dart';
import 'list_card/list_card_widget.dart';

class ListCards extends ConsumerWidget {
  final List<Location> locations;
  final BuildContext mainContext;

  const ListCards({
    required this.locations,
    required this.mainContext,
  });

  Future<void> deleteLocation({
    required WidgetRef ref,
    required BuildContext context,
    required Location location,
    required int index,
  }) async {
    final locationsBeforeDelete = ref.read(hiveProvider);

    await ref.read(hiveProvider.notifier).deleteLocationFromBox(
          passedLocation: location,
          index: index,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${location.name}, ${location.country} is deleted.',
          style: PromajaTextStyles.snackbar,
        ),
        action: SnackBarAction(
          label: 'Undo'.toUpperCase(),
          textColor: PromajaColors.white,
          onPressed: () => ref.read(hiveProvider.notifier).writeAllLocationsToHive(locations: locationsBeforeDelete),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) => ReorderableListView.builder(
        onReorder: ref.read(hiveProvider.notifier).reorderLocations,
        scrollController: ref.watch(addLocationProvider.notifier).scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const BouncingScrollPhysics(),
        itemCount: locations.length + 1,
        itemBuilder: (_, index) {
          ///
          /// ADD LOCATION
          ///
          if (index == locations.length) {
            return const Padding(
              padding: EdgeInsets.only(top: 16),
              child: AddLocationResult(),
            );
          }

          ///
          /// WEATHER CARD
          ///
          final location = locations[index];

          return ListCardWidget(
            location: location,
            index: index,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WeatherScreen(
                  location: location,
                ),
              ),
            ),
            onTapDelete: () => deleteLocation(
              ref: ref,
              context: context,
              location: location,
              index: index,
            ),
          );
        },
      );
}
