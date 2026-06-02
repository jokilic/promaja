import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:watch_it/watch_it.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../constants/typedefs.dart';
import '../../../../services/hive_service.dart';
import '../../../../util/dependencies.dart';
import '../../../../util/error.dart';
import '../../../../util/snackbars.dart';
import '../../controllers/list_add_location_controller.dart';
import '../../controllers/list_phone_location_controller.dart';

class AddLocationWidget extends WatchingStatefulWidget {
  @override
  State<AddLocationWidget> createState() => _AddLocationWidgetState();
}

class _AddLocationWidgetState extends State<AddLocationWidget> {
  @override
  void initState() {
    super.initState();

    /// Clear [TextField]
    getIt.get<ListAddLocationController>().textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    registerHandler<ListAddLocationController, ({SearchResult searchResult, bool loading})>(
      select: (controller) => controller,
      handler: (context, state, _) {
        final errorText = getErrorText(state);

        if (errorText != null) {
          showErrorSnackbar(
            context: context,
            errorText: errorText,
          );
        }
      },
    );

    registerHandler<ListPhoneLocationController, ({Position? position, String? error, bool loading})>(
      select: (controller) => controller,
      handler: (context, state, _) {
        if (state.error != null) {
          showErrorSnackbar(
            context: context,
            errorText: state.error!,
          );
        }
      },
    );

    final listAddLocationState = watchIt<ListAddLocationController>().value;
    final listPhoneLocationState = watchIt<ListPhoneLocationController>().value;
    final hiveState = watchIt<HiveService>().value;

    final isLoading = listAddLocationState.loading;
    final locations = listAddLocationState.searchResult.response;

    final isLoadingPhone = listPhoneLocationState.loading;
    final hasPhoneLocation = hiveState.any(
      (location) => location.isPhoneLocation ?? false,
    );

    final listAddLocation = getIt.get<ListAddLocationController>();
    final listPhoneLocation = getIt.get<ListPhoneLocationController>();

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
              onSubmitted: listAddLocation.searchPlace,
              controller: listAddLocation.textEditingController,
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
                    onPressed: !isLoadingPhone ? listPhoneLocation.enablePhoneLocation : null,
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
                    onTap: () => listAddLocation.addPlace(
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
