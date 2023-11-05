import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/icons.dart';

String getForecastDate({required DateTime dateEpoch}) {
  /// Current date and time
  final now = DateTime.now();

  /// Today date
  final today = DateTime(now.year, now.month, now.day);

  /// Tomorrow date
  final tomorrow = today.add(const Duration(days: 1));

  final passedDate = DateTime(dateEpoch.year, dateEpoch.month, dateEpoch.day);

  if (passedDate.isAtSameMomentAs(today)) {
    return 'today'.tr();
  } else if (passedDate.isAtSameMomentAs(tomorrow)) {
    return 'tomorrow'.tr();
  } else {
    return DateFormat.yMMMMd().format(dateEpoch);
  }
}

String getWeatherDescription({required int code, required bool isDay}) => '$code${isDay ? 'Day' : 'Night'}'.tr();

Color getWeatherColor({required int code, required bool isDay}) {
  switch (code) {
    case 1000:
      return isDay ? PromajaColors.sun : PromajaColors.moon;
    case 1003:
      return isDay ? PromajaColors.sunCloud : PromajaColors.moonCloud;
    case 1006:
    case 1009:
      return PromajaColors.cloud;
    case 1030:
    case 1135:
      return PromajaColors.slowWinds;
    case 1063:
    case 1150:
    case 1153:
    case 1180:
    case 1183:
    case 1240:
      return isDay ? PromajaColors.sunCloudLittleRain : PromajaColors.moonCloudLittleRain;
    case 1066:
    case 1210:
    case 1255:
      return isDay ? PromajaColors.sunCloudLittleSnow : PromajaColors.moonCloudLittleSnow;
    case 1069:
    case 1204:
    case 1249:
    case 1261:
      return isDay ? PromajaColors.sunCloudHailstone : PromajaColors.moonCloudHailstone;
    case 1072:
    case 1198:
      return isDay ? PromajaColors.sunCloudAngledRain : PromajaColors.moonCloudAngledRain;
    case 1087:
    case 1273:
      return isDay ? PromajaColors.sunCloudZap : PromajaColors.moonCloudZap;
    case 1114:
      return PromajaColors.midSnowFastWinds;
    case 1117:
    case 1222:
    case 1225:
      return PromajaColors.bigSnowLittleSnow;
    case 1147:
      return PromajaColors.midSnowSlowWinds;
    case 1168:
    case 1201:
      return PromajaColors.cloudAngledRain;
    case 1071:
      return PromajaColors.cloudBigRain;
    case 1186:
      return isDay ? PromajaColors.sunCloudMidRain : PromajaColors.moonCloudMidRain;
    case 1189:
    case 1243:
      return PromajaColors.cloudMidRain;
    case 1192:
      return isDay ? PromajaColors.sunCloudBigRain : PromajaColors.moonCloudBigRain;
    case 1195:
    case 1246:
      return PromajaColors.bigRainDrops;
    case 1207:
    case 1237:
    case 1252:
    case 1264:
      return PromajaColors.cloudHailstone;
    case 1213:
      return PromajaColors.cloudLittleSnow;
    case 1216:
      return isDay ? PromajaColors.sunCloudMidSnow : PromajaColors.moonCloudMidSnow;
    case 1219:
    case 1258:
      return PromajaColors.cloudMidSnow;
    case 1276:
      return PromajaColors.cloudAngledRainZap;
    case 1279:
    case 1282:
      return PromajaColors.fastWindsZaps;

    default:
      return PromajaColors.fastWinds;
  }
}

String getWeatherIcon({required int code, required bool isDay}) {
  switch (code) {
    case 1000:
      return isDay ? PromajaIcons.sun : PromajaIcons.moon;
    case 1003:
      return isDay ? PromajaIcons.sunCloud : PromajaIcons.moonCloud;
    case 1006:
    case 1009:
      return PromajaIcons.cloud;
    case 1030:
    case 1135:
      return PromajaIcons.slowWinds;
    case 1063:
    case 1150:
    case 1153:
    case 1180:
    case 1183:
    case 1240:
      return isDay ? PromajaIcons.sunCloudLittleRain : PromajaIcons.moonCloudLittleRain;
    case 1066:
    case 1210:
    case 1255:
      return isDay ? PromajaIcons.sunCloudLittleSnow : PromajaIcons.moonCloudLittleSnow;
    case 1069:
    case 1204:
    case 1249:
    case 1261:
      return isDay ? PromajaIcons.sunCloudHailstone : PromajaIcons.moonCloudHailstone;
    case 1072:
    case 1198:
      return isDay ? PromajaIcons.sunCloudAngledRain : PromajaIcons.moonCloudAngledRain;
    case 1087:
    case 1273:
      return isDay ? PromajaIcons.sunCloudZap : PromajaIcons.moonCloudZap;
    case 1114:
      return PromajaIcons.midSnowFastWinds;
    case 1117:
    case 1222:
    case 1225:
      return PromajaIcons.bigSnowLittleSnow;
    case 1147:
      return PromajaIcons.midSnowSlowWinds;
    case 1168:
    case 1201:
      return PromajaIcons.cloudAngledRain;
    case 1071:
      return PromajaIcons.cloudBigRain;
    case 1186:
      return isDay ? PromajaIcons.sunCloudMidRain : PromajaIcons.moonCloudMidRain;
    case 1189:
    case 1243:
      return PromajaIcons.cloudMidRain;
    case 1192:
      return isDay ? PromajaIcons.sunCloudBigRain : PromajaIcons.moonCloudBigRain;
    case 1195:
    case 1246:
      return PromajaIcons.bigRainDrops;
    case 1207:
    case 1237:
    case 1252:
    case 1264:
      return PromajaIcons.cloudHailstone;
    case 1213:
      return PromajaIcons.cloudLittleSnow;
    case 1216:
      return isDay ? PromajaIcons.sunCloudMidSnow : PromajaIcons.moonCloudMidSnow;
    case 1219:
    case 1258:
      return PromajaIcons.cloudMidSnow;
    case 1276:
      return PromajaIcons.cloudAngledRainZap;
    case 1279:
    case 1282:
      return PromajaIcons.fastWindsZaps;

    default:
      return PromajaIcons.fastWinds;
  }
}
