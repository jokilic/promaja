import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/icons.dart';

String getTodayDateMonth({required DateTime dateEpoch}) {
  /// Current date and time
  final now = DateTime.now();

  /// Today date
  final today = DateTime(now.year, now.month, now.day);

  final passedDate = DateTime(dateEpoch.year, dateEpoch.month, dateEpoch.day);

  if (passedDate.isAtSameMomentAs(today)) {
    return 'today'.tr();
  } else {
    final day = DateFormat.EEEE().format(dateEpoch);
    return '${day.substring(0, 1).toUpperCase()}${day.substring(1)}';
  }
}

String getWeatherDescription({required int code, required bool isDay}) => '$code${isDay ? 'Day' : 'Night'}'.tr();

Color getWeatherColor({
  required int code,
  required bool isDay,
}) => switch (code) {
  1000 => isDay ? PromajaColors.sun : PromajaColors.moon,
  1003 => isDay ? PromajaColors.sunCloud : PromajaColors.moonCloud,
  1006 || 1009 => PromajaColors.cloud,
  1030 || 1135 => PromajaColors.slowWinds,
  1063 || 1150 || 1153 || 1180 || 1183 || 1240 => isDay ? PromajaColors.sunCloudLittleRain : PromajaColors.moonCloudLittleRain,
  1066 || 1210 || 1255 => isDay ? PromajaColors.sunCloudLittleSnow : PromajaColors.moonCloudLittleSnow,
  1069 || 1204 || 1249 || 1261 => isDay ? PromajaColors.sunCloudHailstone : PromajaColors.moonCloudHailstone,
  1072 || 1198 => isDay ? PromajaColors.sunCloudAngledRain : PromajaColors.moonCloudAngledRain,
  1087 || 1273 => isDay ? PromajaColors.sunCloudZap : PromajaColors.moonCloudZap,
  1114 => PromajaColors.midSnowFastWinds,
  1117 || 1222 || 1225 => PromajaColors.bigSnowLittleSnow,
  1147 => PromajaColors.midSnowSlowWinds,
  1168 || 1201 => PromajaColors.cloudAngledRain,
  1186 => isDay ? PromajaColors.sunCloudMidRain : PromajaColors.moonCloudMidRain,
  1189 || 1243 => PromajaColors.cloudMidRain,
  1192 => isDay ? PromajaColors.sunCloudBigRain : PromajaColors.moonCloudBigRain,
  1195 || 1246 => PromajaColors.bigRainDrops,
  1207 || 1237 || 1252 || 1264 => PromajaColors.cloudHailstone,
  1213 => PromajaColors.cloudLittleSnow,
  1216 => isDay ? PromajaColors.sunCloudMidSnow : PromajaColors.moonCloudMidSnow,
  1219 || 1258 => PromajaColors.cloudMidSnow,
  1276 => PromajaColors.cloudAngledRainZap,
  1279 || 1282 => PromajaColors.fastWindsZaps,
  _ => PromajaColors.fastWinds,
};

String getWeatherIcon({
  required int code,
  required bool isDay,
}) => switch (code) {
  1000 => isDay ? PromajaIcons.sun : PromajaIcons.moon,
  1003 => isDay ? PromajaIcons.sunCloud : PromajaIcons.moonCloud,
  1006 || 1009 => PromajaIcons.cloud,
  1030 || 1135 => PromajaIcons.slowWinds,
  1063 || 1150 || 1153 || 1180 || 1183 || 1240 => isDay ? PromajaIcons.sunCloudLittleRain : PromajaIcons.moonCloudLittleRain,
  1066 || 1210 || 1255 => isDay ? PromajaIcons.sunCloudLittleSnow : PromajaIcons.moonCloudLittleSnow,
  1069 || 1204 || 1249 || 1261 => isDay ? PromajaIcons.sunCloudHailstone : PromajaIcons.moonCloudHailstone,
  1072 || 1198 => isDay ? PromajaIcons.sunCloudAngledRain : PromajaIcons.moonCloudAngledRain,
  1087 || 1273 => isDay ? PromajaIcons.sunCloudZap : PromajaIcons.moonCloudZap,
  1114 => PromajaIcons.midSnowFastWinds,
  1117 || 1222 || 1225 => PromajaIcons.bigSnowLittleSnow,
  1147 => PromajaIcons.midSnowSlowWinds,
  1168 || 1201 => PromajaIcons.cloudAngledRain,
  1186 => isDay ? PromajaIcons.sunCloudMidRain : PromajaIcons.moonCloudMidRain,
  1189 || 1243 => PromajaIcons.cloudMidRain,
  1192 => isDay ? PromajaIcons.sunCloudBigRain : PromajaIcons.moonCloudBigRain,
  1195 || 1246 => PromajaIcons.bigRainDrops,
  1207 || 1237 || 1252 || 1264 => PromajaIcons.cloudHailstone,
  1213 => PromajaIcons.cloudLittleSnow,
  1216 => isDay ? PromajaIcons.sunCloudMidSnow : PromajaIcons.moonCloudMidSnow,
  1219 || 1258 => PromajaIcons.cloudMidSnow,
  1276 => PromajaIcons.cloudAngledRainZap,
  1279 || 1282 => PromajaIcons.fastWindsZaps,
  _ => PromajaIcons.fastWinds,
};

final weatherCodes = [
  1000,
  1003,
  1006,
  1009,
  1030,
  1135,
  1063,
  1150,
  1153,
  1180,
  1183,
  1240,
  1066,
  1210,
  1255,
  1069,
  1204,
  1249,
  1261,
  1072,
  1198,
  1087,
  1273,
  1114,
  1117,
  1222,
  1225,
  1147,
  1168,
  1201,
  1186,
  1189,
  1243,
  1192,
  1195,
  1246,
  1207,
  1237,
  1252,
  1264,
  1213,
  1216,
  1219,
  1258,
  1276,
  1279,
  1282,
];
