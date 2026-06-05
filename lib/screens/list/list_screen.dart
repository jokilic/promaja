import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:watch_it/watch_it.dart';

import '../../constants/durations.dart';
import '../../models/settings/units/temperature_unit.dart';
import '../../services/api_service.dart';
import '../../services/hive_service.dart';
import '../../services/location_service.dart';
import '../../util/dependencies.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'controllers/add_location_controller.dart';
import 'controllers/phone_location_controller.dart';
import 'widgets/list_cards.dart';
import 'widgets/list_empty.dart';

class ListScreen extends WatchingStatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();

    registerIfNotInitialized<AddLocationController>(
      () => AddLocationController(
        hive: getIt.get<HiveService>(),
        api: getIt.get<APIService>(),
      ),
    );

    registerIfNotInitialized<PhoneLocationController>(
      () => PhoneLocationController(
        hive: getIt.get<HiveService>(),
        api: getIt.get<APIService>(),
        location: getIt.get<LocationService>(),
      ),
    );

    /// Remove splash screen
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    unRegisterIfNotDisposed<AddLocationController>();
    unRegisterIfNotDisposed<PhoneLocationController>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCelsius = getIt.get<HiveService>().getPromajaSettingsFromBox().unit.temperature == TemperatureUnit.celsius;

    final locations = watchIt<HiveService>().value;

    return Scaffold(
      bottomNavigationBar: PromajaNavigationBar(),
      body: Animate(
        effects: [
          FadeEffect(
            curve: Curves.easeIn,
            duration: PromajaDurations.fadeAnimation,
          ),
        ],
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: PromajaDurations.fadeAnimation,
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeIn,
            child: locations.isEmpty
                ? ListEmpty()
                : ListCards(
                    locations: locations,
                    showCelsius: isCelsius,
                  ),
          ),
        ),
      ),
    );
  }
}
