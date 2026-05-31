import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:watch_it/watch_it.dart';

import 'constants/colors.dart';
import 'generated/codegen_loader.g.dart';
import 'services/screen_service.dart';
import 'util/dependencies.dart';
import 'util/display_mode.dart';
import 'widgets/promaja_error_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  /// Initialize Flutter related tasks
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Keep splash until first data is fetched
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Remove splash if data is fetching more than 5 seconds
  Timer(
    const Duration(seconds: 5),
    FlutterNativeSplash.remove,
  );

  /// Initialize everything before starting app
  await initializeBeforeAppStart();

  /// Run `Promaja`
  runApp(
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: PromajaColors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: PromajaApp(),
    ),
  );
}

/// Initialize all functionality before starting app
Future<void> initializeBeforeAppStart() async {
  /// Override the default error widget
  ErrorWidget.builder = (details) => PromajaErrorWidget(
    error: details.exceptionAsString(),
  );

  /// Make sure the orientation is only `portrait`
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /// Use `edge-to-edge` display
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  /// Set refresh rate to high
  await setDisplayMode();

  /// Initialize localization
  await initializeLocalization();

  /// Initialize services
  await initializeServices();
}

class PromajaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => EasyLocalization(
    useOnlyLangCode: true,
    supportedLocales: const [
      Locale('hr'),
      Locale('en'),
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('hr'),
    assetLoader: const CodegenLoader(),
    child: Builder(
      builder: (context) => MaterialApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: PromajaWidget(),
        onGenerateTitle: (_) => 'appNameString'.tr(),
        theme: ThemeData(
          fontFamily: 'ProductSans',
          scaffoldBackgroundColor: PromajaColors.black,
          canvasColor: PromajaColors.black,
          colorScheme: const ColorScheme.dark(
            surface: PromajaColors.black,
          ),
        ),
      ),
    ),
  );
}

class PromajaWidget extends WatchingWidget {
  @override
  Widget build(BuildContext context) => getIt.get<ScreenService>().getProperWidget(
    watchIt<ScreenService>().value,
  );
}
