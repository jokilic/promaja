import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'services/alice_service.dart';
import 'services/api_service.dart';
import 'services/connectivity_service.dart';
import 'services/device_info_service.dart';
import 'services/dio_service.dart';
import 'services/location_service.dart';
import 'services/logger_service.dart';
import 'services/package_info_service.dart';
import 'util/language.dart';

///
/// Providers for services used throughout the app
///

final loggerProvider = Provider(
  (_) => LoggerService(),
  name: 'LoggerProvider',
);
final aliceProvider = Provider(
  (_) => AliceService(),
  name: 'AliceProvider',
);
final deviceInfoProvider = Provider(
  (ref) => DeviceInfoService(
    logger: ref.watch(loggerProvider),
  ),
  name: 'DeviceInfoProvider',
);
final dioProvider = Provider(
  (ref) => DioService(
    alice: ref.watch(aliceProvider),
    logger: ref.watch(loggerProvider),
  ),
  name: 'DioProvider',
);
final packageInfoProvider = Provider(
  (ref) => PackageInfoService(
    logger: ref.watch(loggerProvider),
  ),
  name: 'PackageInfoProvider',
);
final locationProvider = Provider(
  (ref) => LocationService(
    logger: ref.watch(loggerProvider),
  ),
  name: 'LocationProvider',
);
final connectivityProvider = Provider(
  (ref) => ConnectivityService(
    logger: ref.watch(loggerProvider),
  ),
  name: 'ConnectivityProvider',
);
final apiServiceProvider = Provider.family<ApiService, BuildContext>(
  (ref, context) => ApiService(
    dio: ref.watch(dioProvider),
    langQueryParameter: getLangQueryParameter(context),
  ),
  name: 'ApiServiceProvider',
);
