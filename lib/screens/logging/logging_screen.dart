import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/text_styles.dart';
import '../../models/promaja_log/promaja_log.dart';
import '../../models/promaja_log/promaja_log_level.dart';
import '../../services/hive_service.dart';
import '../../util/weather.dart';
import '../../widgets/promaja_back_button.dart';
import '../settings/widgets/settings_popup_menu_list_tile.dart';
import 'logging_notifier.dart';
import 'widgets/logging_list_tile.dart';

class LoggingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(loggingProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: AnimateList(
            interval: PromajaDurations.settingsInterval,
            effects: [
              FadeEffect(
                curve: Curves.easeIn,
                duration: PromajaDurations.fadeAnimation,
              ),
            ],
            children: [
              const SizedBox(height: 16),

              ///
              /// BACK BUTTON
              ///
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    PromajaBackButton(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ///
              /// LOGGING TITLE
              ///
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Logging',
                  style: PromajaTextStyles.settingsTitle,
                ),
              ),
              const SizedBox(height: 16),

              ///
              /// WIDGET DESCRIPTION
              ///
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Here you can find all logs explaining app behaviour.',
                  style: PromajaTextStyles.settingsText,
                ),
              ),

              ///
              /// DIVIDER
              ///
              const SizedBox(height: 24),
              const Divider(
                indent: 120,
                endIndent: 120,
                color: PromajaColors.white,
              ),
              const SizedBox(height: 4),

              ///
              /// LOG FILTER
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => ref.read(loggingProvider.notifier).tapDownDetails = details,
                onTapUp: (_) async {
                  final newLogFilter = await ref.read(loggingProvider.notifier).showLogFilterPopupMenu(context);

                  ref.read(loggingProvider.notifier).updateLogs(visibleLevel: newLogFilter);

                  ref.read(hiveProvider.notifier).logPromajaEvent(
                        text: 'Log filter -> ${newLogFilter != null ? newLogFilter.name : 'All'}',
                        logLevel: PromajaLogLevel.logging,
                      );
                },
                activeValue: logs.logFilter != null ? localizeLogLevel(logs.logFilter!) : 'All',
                subtitle: 'Choose a log filter to be visible',
              ),

              const SizedBox(height: 8),

              ///
              /// LOGS
              ///
              GroupedListView<PromajaLog, String>(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                elements: logs.list,
                groupBy: (log) => DateTime(log.time.year, log.time.month, log.time.day).toIso8601String(),
                groupSeparatorBuilder: (groupByValue) => Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
                  child: Text(
                    getForecastDate(dateEpoch: DateTime.parse(groupByValue)),
                    style: PromajaTextStyles.settingsSubtitle,
                  ),
                ),
                itemBuilder: (_, log) => LoggingListTile(
                  onTap: () {},
                  text: log.text,
                  time: DateFormat.Hm().format(log.time),
                  icon: ref.read(loggingProvider.notifier).getLoggingIcon(log.logLevel),
                  isError: log.isError,
                ),
                itemComparator: (log1, log2) => log1.time.compareTo(log2.time),
                order: GroupedListOrder.DESC,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
