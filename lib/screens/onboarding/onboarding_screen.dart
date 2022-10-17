import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'onboarding_controller.dart';

class OnboardingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingController = ref.watch(onboardingProvider);

    return const Scaffold(
      body: Text('Onboarding'),
    );
  }
}
