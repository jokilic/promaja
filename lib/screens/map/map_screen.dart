import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/durations.dart';
import '../../widgets/promaja_navigation_bar.dart';

class MapScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    bottomNavigationBar: PromajaNavigationBar(),
    body: Animate(
      key: ValueKey(ref.read(navigationBarIndexProvider)),
      effects: [
        FadeEffect(
          curve: Curves.easeIn,
          duration: PromajaDurations.fadeAnimation,
        ),
      ],
      child: Container(
        height: 100,
        width: 100,
        color: Colors.indigo,
      ),
    ),
  );
}
