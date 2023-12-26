import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/promaja_log/promaja_log.dart';
import '../../models/promaja_log/promaja_log_level.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

final loggingProvider = StateNotifierProvider.autoDispose<LoggingNotifier, ({List<PromajaLog> list, PromajaLogLevel? logFilter})>(
  (ref) => LoggingNotifier(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'LoggingProvider',
);

class LoggingNotifier extends StateNotifier<({List<PromajaLog> list, PromajaLogLevel? logFilter})> {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final HiveService hive;

  LoggingNotifier({
    required this.logger,
    required this.hive,
  }) : super((
          list: hive.getPromajaLogsFromBox().reversed.toList(),
          logFilter: null,
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
  void updateLogs({PromajaLogLevel? visibleLevel}) {
    final logs = hive.getPromajaLogsFromBox().reversed.toList();
    final newList = visibleLevel != null ? logs.where((log) => log.logLevel == visibleLevel).toList() : logs;

    state = (list: newList, logFilter: visibleLevel);
  }

  /// Opens popup menu which chooses logging filter
  Future<PromajaLogLevel?> showLogFilterPopupMenu(BuildContext context) async {
    final left = tapDownDetails?.globalPosition.dx ?? 0;
    final top = tapDownDetails?.globalPosition.dy ?? 0;

    const logLevels = PromajaLogLevel.values;

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
        const PopupMenuItem(
          padding: EdgeInsets.all(20),
          child: Text(
            'All',
            style: PromajaTextStyles.settingsPopupMenuItem,
          ),
        ),
        ...logLevels
            .map(
              (logLevel) => PopupMenuItem(
                value: logLevel,
                padding: const EdgeInsets.all(20),
                child: Text(
                  localizeLogLevel(logLevel),
                  style: PromajaTextStyles.settingsPopupMenuItem,
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  /// Returns proper icon for [LoggingListTile]
  IconData getLoggingIcon(PromajaLogLevel logLevel) {
    // TODO: Find proper icons from FlatIcon

    switch (logLevel) {
      case PromajaLogLevel.info:
        return Icons.info_rounded;
      case PromajaLogLevel.api:
        return Icons.api_rounded;
      case PromajaLogLevel.currentWeather:
        return Icons.wb_sunny_rounded;
      case PromajaLogLevel.forecastWeather:
        return Icons.cloud_rounded;
      case PromajaLogLevel.list:
        return Icons.list_rounded;
      case PromajaLogLevel.settings:
        return Icons.settings_rounded;
      case PromajaLogLevel.notification:
        return Icons.notifications_rounded;
      case PromajaLogLevel.widget:
        return Icons.widgets_rounded;
      case PromajaLogLevel.location:
        return Icons.location_on_rounded;
    }
  }
}
