import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';
import '../../../models/location/location.dart';
import '../../../services/hive_service.dart';
import '../../../services/screen_service.dart';
import '../../../util/dependencies.dart';
import '../controllers/add_location_controller.dart';
import 'add_location/add_location_widget.dart';
import 'list_card/list_card_widget.dart';

class ListCards extends StatelessWidget {
  final List<Location> locations;
  final bool showCelsius;

  const ListCards({
    required this.locations,
    required this.showCelsius,
  });

  Future<void> deleteLocation({
    required BuildContext context,
    required Location location,
    required int index,
  }) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    await getIt.get<HiveService>().deleteLocationFromBox(index: index);

    scaffoldMessenger.showSnackBar(
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

  Future<void> openWeatherScreen({required int index}) async {
    await getIt.get<HiveService>().addActiveLocationIndexToBox(index: index);

    await getIt.get<ScreenService>().changeNavigationBarItem(
      NavigationBarItem.weather,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hive = getIt.get<HiveService>();
    final addLocation = getIt.get<AddLocationController>();

    return Column(
      children: [
        ///
        /// ADD NEW LOCATION
        ///
        Padding(
          key: const ValueKey('add_location'),
          padding: const EdgeInsets.only(top: 16),
          child: AddLocationWidget(),
        ),
        const SizedBox(height: 8),

        ///
        /// LIST OF LOCATIONS
        ///
        Flexible(
          child: ReorderableListView.builder(
            onReorderItem: hive.reorderLocations,
            padding: const EdgeInsets.symmetric(vertical: 8),
            physics: const BouncingScrollPhysics(),
            scrollController: addLocation.scrollController,
            itemCount: locations.length + 1, // + 1 for the empty item at the end
            itemBuilder: (context, index) {
              if (index == locations.length) {
                return SizedBox.shrink(
                  key: UniqueKey(),
                );
              }

              final location = locations[index];

              return ListCardWidget(
                index: index,
                key: ValueKey(location),
                originalLocation: location,
                showCelsius: showCelsius,
                onTap: () => openWeatherScreen(
                  index: index,
                ),
                onTapDelete: (handler) {
                  handler(false);
                  deleteLocation(
                    context: context,
                    location: location,
                    index: index,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
