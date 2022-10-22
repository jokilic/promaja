import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsController = ref.watch(settingsProvider);

    return const Scaffold(
      body: Center(
        child: Text('SettingsScreen'),
      ),
    );
  }
}
