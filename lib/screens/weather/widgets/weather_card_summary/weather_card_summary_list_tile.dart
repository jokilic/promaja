import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/forecast_day_weather.dart';
import '../../../../util/weather.dart';

class WeatherCardSummaryListTile extends StatelessWidget {
  final ForecastDayWeather forecast;
  final bool showCelsius;

  const WeatherCardSummaryListTile({
    required this.forecast,
    required this.showCelsius,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        splashColor: PromajaColors.white.withOpacity(0.15),
        onTap: () {},
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        title: Text(
          getForecastDate(
            dateEpoch: forecast.dateEpoch,
            isShortMonth: true,
          ),
          style: PromajaTextStyles.settingsSubtitle,
        ),
        subtitle: Text(
          getWeatherDescription(
            code: forecast.day.condition.code,
            isDay: true,
          ),
          style: PromajaTextStyles.settingsText,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              showCelsius ? '${forecast.day.minTempC.round()}°' : '${forecast.day.minTempF.round()}°',
              style: PromajaTextStyles.weatherSummaryTemperatureMin,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 8),
            Text(
              showCelsius ? '${forecast.day.maxTempC.round()}°' : '${forecast.day.maxTempF.round()}°',
              style: PromajaTextStyles.weatherSummaryTemperatureMax,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 16),
            Transform.scale(
              scale: 1.2,
              child: Image.asset(
                getWeatherIcon(
                  code: forecast.day.condition.code,
                  isDay: true,
                ),
                height: 48,
                width: 48,
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      );
}
