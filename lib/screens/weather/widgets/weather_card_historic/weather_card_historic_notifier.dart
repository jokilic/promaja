import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/icons.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/location/location.dart';
import '../../../../util/weather.dart';
import 'weather_card_historic.dart';

final weatherCardHistoricProvider = StateNotifierProvider.autoDispose.family<WeatherCardHistoricNotifier, String?, Location>(
  (ref, location) => WeatherCardHistoricNotifier(
    location: location,
  ),
  name: 'WeatherCardHistoricProvider',
);

class WeatherCardHistoricNotifier extends StateNotifier<String?> {
  final Location location;

  WeatherCardHistoricNotifier({
    required this.location,
  }) : super(null);

  ///
  /// METHODS
  ///

  Future<void> showCalendar(BuildContext context) async {
    final now = DateTime.now();

    final pickedDate = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        currentDate: now,
        firstDate: now.subtract(const Duration(days: 8)),
        lastDate: now,
        weekdayLabelTextStyle: PromajaTextStyles.calendarWeekday,
        controlsTextStyle: PromajaTextStyles.calendarWeekday,
        dayTextStyle: PromajaTextStyles.calendarWeekday,
        todayTextStyle: PromajaTextStyles.calendarWeekday,
        selectedDayTextStyle: PromajaTextStyles.calendarWeekday.copyWith(
          color: PromajaColors.indigo,
        ),
        selectedMonthTextStyle: PromajaTextStyles.calendarWeekday,
        selectedYearTextStyle: PromajaTextStyles.calendarWeekday,
        disabledDayTextStyle: PromajaTextStyles.calendarWeekday.copyWith(
          color: PromajaColors.white.withOpacity(0.25),
        ),
        selectedDayHighlightColor: PromajaColors.white,
        daySplashColor: PromajaColors.indigo,
        firstDayOfWeek: 1,
        useAbbrLabelForMonthModePicker: true,
        disableModePicker: true,
        disableMonthPicker: true,
        cancelButton: Text(
          'calendarCancel'.tr().toUpperCase(),
          style: PromajaTextStyles.calendarButton,
        ),
        okButton: Text(
          'calendarGo'.tr().toUpperCase(),
          style: PromajaTextStyles.calendarButton,
        ),
        lastMonthIcon: Transform.rotate(
          angle: pi,
          child: Image.asset(
            PromajaIcons.arrow,
            color: PromajaColors.white,
            height: 24,
            width: 24,
          ),
        ),
        nextMonthIcon: Image.asset(
          PromajaIcons.arrow,
          color: PromajaColors.white,
          height: 24,
          width: 24,
        ),
      ),
      borderRadius: BorderRadius.circular(8),
      dialogBackgroundColor: PromajaColors.indigo,
      dialogSize: const Size(325, 400),
    );

    final date = pickedDate?.firstOrNull;

    if (date != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WeatherCardHistoric(
            location: location,
            historicDate: getHistoryDate(date),
          ),
        ),
      );
    }
  }
}
