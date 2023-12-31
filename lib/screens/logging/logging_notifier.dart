import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/promaja_log/promaja_log.dart';
import '../../models/promaja_log/promaja_log_level.dart';
import '../../services/hive_service.dart';
import '../../services/logger_service.dart';

final loggingProvider = StateNotifierProvider.autoDispose<LoggingNotifier, ({List<PromajaLog> list, String? logGroup})>(
  (ref) => LoggingNotifier(
    logger: ref.watch(loggerProvider),
    hive: ref.watch(hiveProvider.notifier),
  ),
  name: 'LoggingProvider',
);

class LoggingNotifier extends StateNotifier<({List<PromajaLog> list, String? logGroup})> {
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
          logGroup: 'all',
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
  void updateLogs({String? visibleLevel}) {
    final logs = hive.getPromajaLogsFromBox();

    /// User picked `All`
    if (visibleLevel == 'all') {
      state = (list: logs, logGroup: visibleLevel);
      return;
    }

    /// User picked `Errors`
    if (visibleLevel == 'errors') {
      final newList = logs.where((log) => log.isError).toList();
      state = (list: newList, logGroup: visibleLevel);
      return;
    }

    /// User picked one of the `PromajaLogGroup` values
    if (visibleLevel != null) {
      final newList = logs.where((log) => log.logGroup.name == visibleLevel).toList();
      state = (list: newList, logGroup: visibleLevel);
    }
  }

  /// Returns proper value for the `active log`
  String getLocalizedLogValue(String? logGroup) {
    if (logGroup == 'all') {
      return 'loggingAll'.tr();
    }

    if (logGroup == 'errors') {
      return 'loggingErrors'.tr();
    }

    if (logGroup != null) {
      return localizeLogGroup(PromajaLogGroup.values.byName(logGroup));
    }

    return 'No value';
  }

  /// Opens popup menu which chooses logging group
  Future<String?> showLogGroupPopupMenu(BuildContext context) async {
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
          value: 'all',
          padding: const EdgeInsets.all(20),
          child: Text(
            'loggingAll'.tr(),
            style: PromajaTextStyles.settingsPopupMenuItem,
          ),
        ),
        PopupMenuItem(
          value: 'errors',
          padding: const EdgeInsets.all(20),
          child: Text(
            'loggingErrors'.tr(),
            style: PromajaTextStyles.settingsPopupMenuItem.copyWith(
              color: PromajaColors.red,
            ),
          ),
        ),
        ...logGroups
            .map(
              (logGroup) => PopupMenuItem(
                value: logGroup.name,
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
}
