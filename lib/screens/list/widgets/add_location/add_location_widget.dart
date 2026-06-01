import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../services/hive_service.dart';
import '../../../../util/dependencies.dart';
import '../../controllers/add_location_controller.dart';
import '../../controllers/phone_location_controller.dart';

class AddLocationWidget extends WatchingStatefulWidget {
  @override
  State<AddLocationWidget> createState() => _AddLocationWidgetState();
}

class _AddLocationWidgetState extends State<AddLocationWidget> {
  @override
  void initState() {
    super.initState();

    /// Clear [TextField]
    getIt.get<AddLocationController>().textEditingController.clear();

    /// Refresh phone location if necessary
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => getIt.get<PhoneLocationController>().refreshPhoneLocation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addLocationState = watchIt<AddLocationController>().value;
    final phoneLocationState = watchIt<PhoneLocationController>().value;
    final hiveState = watchIt<HiveService>().value;

    final isLoading = addLocationState.loading;
    final locations = addLocationState.searchResult.response;

    final isLoadingPhone = phoneLocationState.loading;
    final hasPhoneLocation = hiveState.any(
      (location) => location.isPhoneLocation ?? false,
    );

    final addLocation = getIt.get<AddLocationController>();
    final phoneLocation = getIt.get<PhoneLocationController>();

    // TODO: Handle this properly
    ///
    /// ERROR HANDLING
    ///
    // ref
    //   ..listen(
    //     addLocationProvider,
    //     (_, state) {
    //       /// Generate potential error
    //       final errorText = getErrorText(state);

    //       /// Show snackbar if error exists
    //       if (errorText != null) {
    //         ScaffoldMessenger.of(context).hideCurrentSnackBar();

    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text(
    //               errorText,
    //               style: PromajaTextStyles.snackbar,
    //             ),
    //             backgroundColor: PromajaColors.black,
    //             behavior: SnackBarBehavior.floating,
    //             elevation: 0,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(8),
    //               side: const BorderSide(
    //                 color: PromajaColors.white,
    //                 width: 2,
    //               ),
    //             ),
    //           ),
    //         );
    //       }
    //     },
    //   )
    //   ..listen(
    //     phoneLocationProvider,
    //     (_, state) {
    //       if (state.error != null) {
    //         ScaffoldMessenger.of(context).hideCurrentSnackBar();

    //         /// Show snackbar
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(
    //             content: Text(
    //               '${state.error}',
    //               style: PromajaTextStyles.snackbar,
    //             ),
    //             backgroundColor: PromajaColors.black,
    //             behavior: SnackBarBehavior.floating,
    //             elevation: 0,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(8),
    //               side: const BorderSide(
    //                 color: PromajaColors.white,
    //                 width: 2,
    //               ),
    //             ),
    //           ),
    //         );
    //       }
    //     },
    //   );

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
              onSubmitted: addLocation.searchPlace,
              controller: addLocation.textEditingController,
              backgroundColor: WidgetStateProperty.all(
                PromajaColors.white,
              ),
              elevation: WidgetStateProperty.all(0),
              textStyle: WidgetStateProperty.all(
                PromajaTextStyles.searchTextField,
              ),
              hintStyle: WidgetStateProperty.all(
                PromajaTextStyles.searchTextFieldHint,
              ),
              hintText: 'searchForPlace'.tr(),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 12),
              ),
              leading: Image.asset(
                PromajaIcons.search,
                height: 20,
                width: 20,
                color: PromajaColors.black,
              ),
              trailing: [
                if (!hasPhoneLocation)
                  IconButton(
                    onPressed: !isLoadingPhone ? phoneLocation.enablePhoneLocation : null,
                    icon: isLoadingPhone
                        ? const Icon(
                            Icons.hourglass_top_rounded,
                            color: PromajaColors.black,
                          )
                        : Image.asset(
                            PromajaIcons.location,
                            height: 24,
                            width: 24,
                            color: PromajaColors.black,
                          ),
                  ),
              ],
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
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
                title: Text(
                  'loading'.tr(),
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
                    onTap: () => addLocation.addPlace(
                      location: location,
                    ),
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
                      'tapToAdd'.tr(),
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
                title: Text(
                  'noLocationFound'.tr(),
                  style: PromajaTextStyles.searchResult,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
