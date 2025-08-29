import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stack_trace/stack_trace.dart';

import 'constants/colors.dart';
import 'generated/codegen_loader.g.dart';
import 'services/hive_service.dart';
import 'services/logger_service.dart';
import 'util/env.dart';
import 'util/initialization.dart';
import 'widgets/promaja_error_widget.dart';
import 'widgets/promaja_navigation_bar.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  try {
    /// Initialize Flutter related tasks
    WidgetsFlutterBinding.ensureInitialized();

    /// Override the default error widget
    ErrorWidget.builder = (details) => PromajaErrorWidget(
      error: details.exceptionAsString(),
    );

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

    /// Initialize [EasyLocalization]
    await initializeLocalization();

    /// Initialize services
    final container = await initializeServices();

    if (container != null) {
      /// Init [Sentry] & run [Promaja]
      await SentryFlutter.init(
        (options) => options
          ..dsn = kDebugMode || kIsWeb ? '' : Env.sentryDsn
          ..debug = kDebugMode,
        appRunner: () => runApp(
          UncontrolledProviderScope(
            container: container,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.black,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
              child: PromajaApp(),
            ),
          ),
        ),
      );
    } else {
      runApp(
        MaterialApp(
          home: const Scaffold(
            body: PromajaErrorWidget(
              error: 'Initialization error',
            ),
          ),
          theme: ThemeData(
            fontFamily: 'Jost',
            scaffoldBackgroundColor: PromajaColors.black,
          ),
        ),
      );
    }
  } catch (e) {
    final logger = LoggerService();
    final hive = HiveService(logger);
    await hive.init();
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
          fontFamily: 'Jost',
          scaffoldBackgroundColor: PromajaColors.black,
        ),
      ),
    ),
  );
}
