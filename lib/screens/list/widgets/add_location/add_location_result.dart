import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../notifiers/add_location_notifier.dart';

class AddLocationResult extends ConsumerWidget {
  const AddLocationResult({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(addLocationProvider).loading;
    final locations = ref.watch(addLocationProvider).response;

    ref.listen(
      addLocationProvider,
      (_, state) {
        if (state.error != null || (state.response?.isEmpty ?? false)) {
          late String text;

          if (state.error != null) {
            text = '${state.error}';
          }

          if (state.response?.isEmpty ?? false) {
            text = 'No locations found';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                text,
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
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            SearchBar(
              controller: ref.watch(addLocationProvider.notifier).textEditingController,
              backgroundColor: MaterialStateProperty.all(
                PromajaColors.white,
              ),
              elevation: MaterialStateProperty.all(0),
              textStyle: MaterialStateProperty.all(
                PromajaTextStyles.searchTextField,
              ),
              hintStyle: MaterialStateProperty.all(
                PromajaTextStyles.searchTextFieldHint,
              ),
              hintText: 'Search for a place...',
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 12),
              ),
              leading: Image.asset(
                PromajaIcons.search,
                height: 20,
                width: 20,
                color: PromajaColors.black,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onSubmitted: ref.read(addLocationProvider.notifier).searchPlace,
            ),

            ///
            /// Loading locations
            ///
            if (isLoading)
              ListTile(
                onTap: () {},
                tileColor: PromajaColors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                leading: const Icon(
                  Icons.hourglass_top_rounded,
                  color: PromajaColors.black,
                ),
                title: const Text(
                  'Loading...',
                  style: PromajaTextStyles.searchResult,
                ),
              ),

            ///
            /// Locations are found
            ///
            if (locations != null)
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: locations.length,
                itemBuilder: (_, index) {
                  final location = locations[index];

                  return ListTile(
                    onTap: () => ref.read(addLocationProvider.notifier).addPlace(location: location),
                    tileColor: PromajaColors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    leading: const Icon(
                      Icons.public_rounded,
                      color: PromajaColors.black,
                    ),
                    title: Text(
                      '${location.name}, ${location.country}',
                      style: PromajaTextStyles.searchResult,
                    ),
                    subtitle: Text(
                      'Tap to add',
                      style: PromajaTextStyles.searchResultSubtitle,
                    ),
                  );
                },
              ),

            ///
            /// No location is found
            ///
            if (locations?.isEmpty ?? false)
              ListTile(
                onTap: () {},
                tileColor: PromajaColors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                leading: const Icon(
                  Icons.public_off_rounded,
                  color: PromajaColors.black,
                ),
                title: const Text(
                  'No location found',
                  style: PromajaTextStyles.searchResult,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
