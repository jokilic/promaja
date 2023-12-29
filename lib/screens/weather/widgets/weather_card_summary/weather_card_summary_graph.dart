import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/forecast_weather.dart';
import '../../weather_notifiers.dart';

class WeatherCardSummaryGraph extends ConsumerWidget {
  final ForecastWeather forecastWeather;
  final bool showCelsius;

  const WeatherCardSummaryGraph({
    required this.forecastWeather,
    required this.showCelsius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSummaryWeather = ref.watch(activeSummaryWeatherProvider);

    final minHourWeather = activeSummaryWeather?.hours.reduce(
      (currentMax, weather) => (showCelsius ? (currentMax.tempC < weather.tempC) : (currentMax.tempF > weather.tempF)) ? currentMax : weather,
    );
    final maxHourWeather = activeSummaryWeather?.hours.reduce(
      (currentMax, weather) => (showCelsius ? (currentMax.tempC > weather.tempC) : (currentMax.tempF > weather.tempF)) ? currentMax : weather,
    );

    final minTemp = showCelsius ? minHourWeather?.tempC : minHourWeather?.tempF;
    final maxTemp = showCelsius ? maxHourWeather?.tempC : maxHourWeather?.tempF;

    final interval = ((minTemp ?? 1) + (maxTemp ?? 1)) / 2;

    return Center(
      child: SizedBox(
        height: 180,
        width: MediaQuery.sizeOf(context).width - 56,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                isStrokeCapRound: true,
                isStrokeJoinRound: true,
                barWidth: 4,
                color: PromajaColors.white,
                dotData: const FlDotData(
                  show: false,
                ),
                spots: List.generate(
                  activeSummaryWeather?.hours.length ?? 0,
                  (index) {
                    final hourModel = activeSummaryWeather!.hours[index];
                    final hour = double.tryParse(DateFormat.H().format(hourModel.timeEpoch));

                    return FlSpot(
                      hour ?? index.toDouble(),
                      showCelsius ? hourModel.tempC : hourModel.tempF,
                    );
                  },
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              getTouchLineStart: (_, __) => 0,
              getTouchLineEnd: (_, __) => 0,
              touchTooltipData: LineTouchTooltipData(
                tooltipRoundedRadius: 100,
                tooltipBgColor: PromajaColors.indigo,
                getTooltipItems: (touchedSpots) => touchedSpots
                    .map(
                      (touchedSpot) => LineTooltipItem(
                        '${touchedSpot.y.round()}°${showCelsius ? 'C' : 'F'}',
                        PromajaTextStyles.summaryGraphTooltip,
                      ),
                    )
                    .toList(),
                tooltipBorder: const BorderSide(
                  color: PromajaColors.white,
                  width: 2,
                ),
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 48,
                  getTitlesWidget: (value, _) => Text(
                    '${value.round()}',
                    style: PromajaTextStyles.summaryGraphTitles,
                  ),
                  showTitles: true,
                  interval: interval,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  getTitlesWidget: (value, _) => Text(
                    '${value.round()}',
                    style: PromajaTextStyles.summaryGraphTitles,
                  ),
                  showTitles: true,
                  interval: 8,
                ),
              ),
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
            ),
            gridData: const FlGridData(
              show: false,
            ),
            borderData: FlBorderData(
              show: false,
            ),
            minY: minTemp != null ? minTemp - 2 : null,
            maxY: maxTemp != null ? maxTemp + 2 : null,
          ),
          duration: PromajaDurations.summaryGraphAnimation,
          curve: Curves.easeIn,
        ),
      ),
    );
  }
}
