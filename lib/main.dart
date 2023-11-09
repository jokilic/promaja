import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stack_trace/stack_trace.dart';

import 'constants/colors.dart';
import 'services/api_service.dart';
import 'services/dio_service.dart';
import 'services/hive_service.dart';
import 'services/home_widget_service.dart';
import 'services/logger_service.dart';
import 'services/work_manager_service.dart';
import 'util/weather.dart';
import 'widgets/promaja_navigation_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Parsing of [StackTrace]
  FlutterError.demangleStackTrace = (stack) {
    if (stack is Trace) {
      return stack.vmTrace;
    }
    if (stack is Chain) {
      return stack.toTrace().vmTrace;
    }
    return stack;
  };

  /// Initialize [EasyLocalization]
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('en');
  await initializeDateFormatting('hr');

  /// Make sure the orientation is only `portrait`
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /// Make sure the status bar shows white text
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light,
  );

  /// Initialize [Logger], [Dio], [WorkManager], [HomeWidget] & [Hive]
  final logger = LoggerService();
  final dio = DioService(logger);
  final workManager = WorkManagerService(logger);
  final homeWidget = HomeWidgetService(logger);
  final hive = HiveService(logger);
  await hive.init();

  runApp(
    ProviderScope(
      overrides: [
        loggerProvider.overrideWithValue(logger),
        dioProvider.overrideWithValue(dio),
        workManagerProvider.overrideWithValue(workManager),
        homeWidgetProvider.overrideWithValue(homeWidget),
        hiveProvider.overrideWith((_) => hive),
      ],
      observers: [
        RiverpodLogger(logger),
      ],
      child: PromajaApp(),
    ),
  );
}

class PromajaApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PromajaAppState();
}

class _PromajaAppState extends ConsumerState<PromajaApp> {
  Future<void> fetchPrimaryLocationForecastAndUpdateHomeWidget() async {
    /// Get primary location
    final location = ref.read(hiveProvider).firstOrNull;

    /// Primary location exists, fetch weather and update [HomeWidget]
    if (location != null) {
      /// Fetch forecast for primary location
      final response = await ref.read(apiProvider).getForecastWeather(
            query: '${location.lat},${location.lon}',
          );

      /// Response is successful
      if (response.response != null && response.error == null) {
        /// Store relevant values in variables
        final locationName = response.response!.location.name;

        final firstDayForecast = response.response!.forecast.forecastDays.first.day;

        final minTemp = firstDayForecast.minTempC.round();
        final maxTemp = firstDayForecast.maxTempC.round();
        final conditionCode = firstDayForecast.condition.code;

        final backgroundColor = getWeatherColor(
          code: conditionCode,
          isDay: true,
        );
        final weatherIcon = getWeatherIcon(
          code: conditionCode,
          isDay: true,
        );
        final weatherDescription = getWeatherDescription(
          code: conditionCode,
          isDay: true,
        );

        /// Create a Flutter widget to show in [HomeWidget]
        final widget = Container(
          height: 200,
          width: 200,
          color: Colors.yellow,
          child: Text(locationName),
        );

        /// Update [HomeWidget]
        await ref.read(homeWidgetProvider).createHomeWidget(widget);

        ref.read(loggerProvider).f('WIDGET IS UPDATED: $locationName');
      }
    }

    /// There are no locations, update [HomeWidget] with empty UI
    else {
      // TODO: Finish this
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPrimaryLocationForecastAndUpdateHomeWidget();
  }

  @override
  Widget build(BuildContext context) => EasyLocalization(
        useOnlyLangCode: true,
        supportedLocales: const [Locale('hr'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('hr'),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: ref.watch(screenProvider),
            onGenerateTitle: (_) => 'appNameString'.tr(),
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Rubik',
              scaffoldBackgroundColor: PromajaColors.black,
            ),
          ),
        ),
      );
}
