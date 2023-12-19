import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/location/location.dart';
import '../../models/settings/promaja_settings.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

final settingsProvider = StateNotifierProvider.autoDispose<SettingsNotifier, PromajaSettings>(
  (ref) => SettingsNotifier(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'SettingsProvider',
);

class SettingsNotifier extends StateNotifier<PromajaSettings> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  SettingsNotifier({
    required this.logger,
    required this.hive,
  }) : super(hive.getPromajaSettingsFromBox())

  ///
  /// INIT
  ///

  {
    /// Notification location is `null`, set it to the first location from [Hive]
    if (state.notification.location == null) {
      final locations = hive.getLocationsFromBox();
      if (locations.isNotEmpty) {
        updateNotificationLocation(locations.first);
      }
    }
  }

  ///
  /// VARIABLES
  ///

  TapDownDetails? tapDownDetails;

  ///
  /// METHODS
  ///

  /// Updates settings with new [PromajaSettings]
  Future<void> updateSettings(PromajaSettings newSettings) async {
    state = newSettings;
    await hive.addPromajaSettingsToBox(promajaSettings: newSettings);
  }

  ///
  /// NOTIFICATION
  ///

  /// Opens popup menu which chooses location to be used in notifications
  Future<Location?> showNotificationLocationPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    final locations = hive.getLocationsFromBox();

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      color: PromajaColors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: PromajaColors.white,
          width: 2.5,
        ),
      ),
      items: locations
          .map(
            (location) => PopupMenuItem(
              value: location,
              padding: const EdgeInsets.all(24),
              onTap: () {},
              child: Text(
                '${location.name}, ${location.country}',
                style: PromajaTextStyles.settingsPopupMenuItem,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Updates location to be used in Notification
  Future<void> updateNotificationLocation(Location newLocation) async => updateSettings(
        state.copyWith(
          notification: state.notification.copyWith(
            location: newLocation,
          ),
        ),
      );

  /// Triggered when the user taps the `Hourly notification` checkbox
  Future<void> toggleHourlyNotification() async => updateSettings(
        state.copyWith(
          notification: state.notification.copyWith(
            hourlyNotification: !state.notification.hourlyNotification,
          ),
        ),
      );

  /// Triggered when the user taps the `Morning notification` checkbox
  Future<void> toggleMonthlyNotification() async => updateSettings(
        state.copyWith(
          notification: state.notification.copyWith(
            morningNotification: !state.notification.morningNotification,
          ),
        ),
      );

  /// Triggered when the user taps the `Evening notification` checkbox
  Future<void> toggleEveningNotification() async => updateSettings(
        state.copyWith(
          notification: state.notification.copyWith(
            eveningNotification: !state.notification.eveningNotification,
          ),
        ),
      );
}
