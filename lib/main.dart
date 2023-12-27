import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_trace/stack_trace.dart';

import 'constants/colors.dart';
import 'generated/codegen_loader.g.dart';
import 'models/promaja_log/promaja_log_level.dart';
import 'services/hive_service.dart';
import 'services/logger_service.dart';
import 'util/initialization.dart';
import 'widgets/promaja_navigation_bar.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  try {
    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

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

    /// Make sure the orientation is only `portrait`
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    /// Make sure the status bar shows white text
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );

    /// Initialize [EasyLocalization]
    await initializeLocalization();

    /// Initialize services
    final container = await initializeServices();

    /// Run [Promaja]
    runApp(
      UncontrolledProviderScope(
        container: container!,
        child: PromajaApp(),
      ),
    );

    container.read(hiveProvider.notifier).logPromajaEvent(
          text: 'App start',
          logLevel: PromajaLogLevel.initialization,
        );
  } catch (e) {
    final logger = LoggerService();
    final hive = HiveService(logger);
    await hive.init();

    hive.logPromajaEvent(
      text: 'App start -> $e',
      logLevel: PromajaLogLevel.initialization,
      isError: true,
    );
  }
}

class PromajaApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => EasyLocalization(
        useOnlyLangCode: true,
        supportedLocales: const [Locale('hr'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('hr'),
        assetLoader: const CodegenLoader(),
        child: Builder(
          builder: (context) => MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: ref.watch(screenProvider),
            onGenerateTitle: (_) => 'appNameString'.tr(),
            theme: ThemeData(
              fontFamily: 'Rubik',
              scaffoldBackgroundColor: PromajaColors.black,
            ),
          ),
        ),
      );
}
