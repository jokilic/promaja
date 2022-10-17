import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'providers.dart';
import 'routes.dart';
import 'services/logger_service.dart';
import 'theme.dart';

///
/// Function first called when running our project
///

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Run the `PromajaApp` app
  runApp(
    ProviderScope(
      observers: [
        RiverpodLogger(
          logger: LoggerService(),
        ),
      ],
      child: PromajaApp(),
    ),
  );
}

///
/// Starting point of our Flutter application
///

class PromajaApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ScreenUtilInit(
        /// Size of `Pixel XL`, device the designer uses in his designs on Figma
        designSize: const Size(412, 732),
        builder: (_, __) => MaterialApp.router(
          key: !Platform.isMacOS ? ref.watch(aliceProvider).alice.getNavigatorKey() : null,
          onGenerateTitle: (_) => 'Promaja',
          theme: theme,
          routerConfig: router,
        ),
      );
}
