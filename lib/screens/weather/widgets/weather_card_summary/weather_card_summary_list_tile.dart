import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/durations.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/forecast_weather/forecast_day_weather.dart';
import '../../../../util/weather.dart';

class WeatherCardSummaryListTile extends StatelessWidget {
  final ForecastDayWeather forecast;
  final Function() onPressed;
  final bool showCelsius;

  const WeatherCardSummaryListTile({
    required this.forecast,
    required this.onPressed,
    required this.showCelsius,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: ListTile(
          selectedTileColor: PromajaColors.white.withOpacity(0.15),
          onTap: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          splashColor: PromajaColors.white.withOpacity(0.15),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          title: Text(
            getTodayDateMonth(
              dateEpoch: forecast.dateEpoch,
            ),
            style: PromajaTextStyles.settingsSubtitle,
          ),
          subtitle: Text(
            getWeatherDescription(
              code: forecast.day.condition.code,
              isDay: true,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
              Animate(
                onPlay: (controller) => controller.loop(reverse: true),
                delay: PromajaDurations.weatherIconScaleDelay,
                effects: [
                  ScaleEffect(
                    curve: Curves.easeIn,
                    end: const Offset(1.25, 1.25),
                    duration: PromajaDurations.weatherIconScalAnimation,
                  ),
                ],
                child: Transform.scale(
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
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      );
}
