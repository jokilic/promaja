import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/error/response_error.dart';
import '../../../../models/location/location.dart';
import '../../../../services/hive_service.dart';
import '../../notifiers/add_location_notifier.dart';
import '../../notifiers/phone_location_notifier.dart';

class AddLocationWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddLocationWidgetState();
}

class _AddLocationWidgetState extends ConsumerState<AddLocationWidget> {
  @override
  void initState() {
    super.initState();

    ref.read(addLocationProvider.notifier).textEditingController.clear();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(phoneLocationProvider.notifier).refreshPhoneLocation(),
    );
  }

  String? getErrorText(({ResponseError? error, String? genericError, bool loading, List<Location>? response}) state) {
    /// Response is empty, there is no locations
    if (state.response?.isEmpty ?? false) {
      return 'noLocationsFound'.tr();
    }

    /// Some error happened
    if (state.error != null || state.genericError != null) {
      return state.error?.error.message ?? state.genericError ?? 'weirdErrorHappened'.tr();
    }

    /// No error happened
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(addLocationProvider).loading;
    final locations = ref.watch(addLocationProvider).response;

    final isLoadingPhone = ref.watch(phoneLocationProvider).loading;
    final hasPhoneLocation = ref.watch(hiveProvider).any(
          (location) => location.isPhoneLocation ?? false,
        );

    ///
    /// ERROR HANDLING
    ///
    ref
      ..listen(
        addLocationProvider,
        (_, state) {
          /// Generate potential error
          final errorText = getErrorText(state);

          /// Show snackbar if error exists
          if (errorText != null) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errorText,
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
        },
      )
      ..listen(
        phoneLocationProvider,
        (_, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            /// Show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${state.error}',
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
              onSubmitted: ref.read(addLocationProvider.notifier).searchPlace,
              controller: ref.watch(addLocationProvider.notifier).textEditingController,
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
                    onPressed: !isLoadingPhone ? ref.read(phoneLocationProvider.notifier).enablePhoneLocation : null,
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
