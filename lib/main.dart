import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stack_trace/stack_trace.dart';

import 'constants/colors.dart';
import 'services/background_service.dart';
import 'services/dio_service.dart';
import 'services/hive_service.dart';
import 'services/home_widget_service.dart';
import 'services/logger_service.dart';
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

  /// Initialize [Logger], [Dio], [BackgroundFetch], [HomeWidget] & [Hive]
  final container = ProviderContainer(
    observers: [
      RiverpodLogger(
        LoggerService(),
      ),
    ],
  )
    ..read(loggerProvider)
    ..read(dioProvider);
  await container.read(backgroundServiceInitializeProvider.future);
  final hive = container.read(hiveProvider.notifier);
  await hive.init();
  container.read(homeWidgetProvider);

  /// Run [Promaja]
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: PromajaApp(),
    ),
  );
}

class PromajaApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => EasyLocalization(
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
