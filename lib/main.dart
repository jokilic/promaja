import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'pages.dart';
import 'providers.dart';
import 'theme.dart';

///
/// This will initialize all services we need throughout the app
///

Provider servicesProvider(BuildContext context) => Provider(
      (ref) => ref
        ..watch(loggerProvider)
        ..watch(aliceProvider)
        ..watch(deviceInfoProvider)
        ..watch(dioProvider)
        ..watch(packageInfoProvider)
        ..watch(locationProvider)
        ..watch(connectivityProvider)
        ..watch(apiServiceProvider(context)),
    );

///
/// Function first called when running our project
///

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Run the `PromajaApp` app
  runApp(
    ProviderScope(
      child: PromajaApp(),
    ),
  );
}

///
/// Starting point of our Flutter application
///

class PromajaApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(servicesProvider(context));

    return ScreenUtilInit(
      /// Size of `Pixel XL`, device the designer uses in his designs on Figma
      designSize: const Size(412, 732),
      builder: (_, __) => MaterialApp(
        navigatorKey: ref.watch(aliceProvider).alice.getNavigatorKey(),
        onGenerateTitle: (_) => 'Promaja',
        theme: theme,
        routes: routes,
        initialRoute: MyRoutes.weatherScreen,
      ),
    );
  }
}
