import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/promaja_log/promaja_log.dart';
import '../../models/promaja_log/promaja_log_level.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

final loggingProvider = StateNotifierProvider.autoDispose<LoggingNotifier, ({List<PromajaLog> list, PromajaLogGroup? logGroup})>(
  (ref) => LoggingNotifier(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'LoggingProvider',
);

class LoggingNotifier extends StateNotifier<({List<PromajaLog> list, PromajaLogGroup? logGroup})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  LoggingNotifier({
    required this.logger,
    required this.hive,
  }) : super((
          list: hive.getPromajaLogsFromBox(),
          logGroup: null,
        ));

  ///
  /// VARIABLES
  ///

  TapDownDetails? tapDownDetails;

  ///
  /// METHODS
  ///

  /// Updates state with only logs of `visibleLevel`
  /// If no `visibleLevel` is passed, it gives a full list of logs
  void updateLogs({PromajaLogGroup? visibleLevel}) {
    final logs = hive.getPromajaLogsFromBox();
    final newList = visibleLevel != null ? logs.where((log) => log.logGroup == visibleLevel).toList() : logs;

    state = (list: newList, logGroup: visibleLevel);
  }

  /// Opens popup menu which chooses logging group
  Future<PromajaLogGroup?> showLogGroupPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    const logGroups = PromajaLogGroup.values;

    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
      color: PromajaColors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: PromajaColors.white,
          width: 2,
        ),
      ),
      items: [
        PopupMenuItem(
          padding: const EdgeInsets.all(20),
          child: Text(
            'loggingAll'.tr(),
            style: PromajaTextStyles.settingsPopupMenuItem,
          ),
        ),
        ...logGroups
            .map(
              (logGroup) => PopupMenuItem(
                value: logGroup,
                padding: const EdgeInsets.all(20),
                child: Text(
                  localizeLogGroup(logGroup),
                  style: PromajaTextStyles.settingsPopupMenuItem,
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  /// Returns proper icon for [LoggingListTile]
  IconData getLoggingIcon(PromajaLogGroup logGroup) => switch (logGroup) {
        PromajaLogGroup.initialization => Icons.info_rounded,
        PromajaLogGroup.api => Icons.api_rounded,
        PromajaLogGroup.currentWeather => Icons.wb_sunny_rounded,
        PromajaLogGroup.forecastWeather => Icons.cloud_rounded,
        PromajaLogGroup.list => Icons.list_rounded,
        PromajaLogGroup.settings => Icons.settings_rounded,
        PromajaLogGroup.notification => Icons.notifications_rounded,
        PromajaLogGroup.widget => Icons.widgets_rounded,
        PromajaLogGroup.location => Icons.location_on_rounded,
        PromajaLogGroup.cardColor => Icons.add_card_rounded,
        PromajaLogGroup.logging => Icons.text_snippet_rounded,
        PromajaLogGroup.unit => Icons.ad_units_rounded,
        PromajaLogGroup.background => Icons.backpack_rounded,
        PromajaLogGroup.navigation => Icons.navigation_rounded,
      };
}
