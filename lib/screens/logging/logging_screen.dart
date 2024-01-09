import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../constants/icons.dart';
import '../../constants/text_styles.dart';
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'loggingTitle'.tr(),
                  style: PromajaTextStyles.settingsTitle,
                ),
              ),
              const SizedBox(height: 16),

              ///
              /// WIDGET DESCRIPTION
              ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'loggingDescription'.tr(),
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
              /// LOG GROUP
              ///
              SettingsPopupMenuListTile(
                onTapDown: (details) => ref.read(loggingProvider.notifier).tapDownDetails = details,
                onTapUp: (_) async {
                  final newLogGroup = await ref.read(loggingProvider.notifier).showLogGroupPopupMenu(context);

                  ref.read(loggingProvider.notifier).updateLogs(visibleLevel: newLogGroup);

                  ref.read(hiveProvider.notifier).logPromajaEvent(
                        text: 'Log group -> ${newLogGroup != null ? '${newLogGroup.substring(0, 1).toUpperCase()}${newLogGroup.substring(1)}' : 'All'}',
                        logGroup: PromajaLogGroup.logging,
                      );
                },
                activeValue: ref.read(loggingProvider.notifier).getLocalizedLogValue(logs.logGroup),
                subtitle: 'loggingLogGroup'.tr(),
              ),

              const SizedBox(height: 8),

              ///
              /// LOGS
              ///
              AnimatedSize(
                duration: PromajaDurations.checkAnimation,
                curve: Curves.easeIn,
                child: AnimatedSwitcher(
                  duration: PromajaDurations.checkAnimation,
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeIn,
                  child: logs.list.isNotEmpty
                      ? GroupedListView(
                          key: ValueKey(logs.logGroup),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          elements: logs.list,
                          groupBy: (log) => DateTime(log.time.year, log.time.month, log.time.day).toIso8601String(),
                          groupSeparatorBuilder: (groupByValue) => Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
                            child: Text(
                              getTodayYesterdayDateMonth(
                                dateEpoch: DateTime.parse(groupByValue),
                              ),
                              style: PromajaTextStyles.settingsSubtitle,
                            ),
                          ),
                          itemBuilder: (_, log) => LoggingListTile(
                            onTap: () {},
                            group: log.logGroup.name,
                            text: log.text,
                            time: DateFormat.Hm().format(log.time),
                            isError: log.isError,
                          ),
                          itemComparator: (log1, log2) => log1.time.compareTo(log2.time),
                          order: GroupedListOrder.DESC,
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 32),
                            Image.asset(
                              PromajaIcons.noLogging,
                              height: 120,
                              width: 120,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 80),
                              child: Text(
                                'loggingNoData'.tr(),
                                style: PromajaTextStyles.settingsSubtitle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
