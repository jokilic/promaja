import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../constants/durations.dart';
import '../../models/map/weather_map_overlay_style.dart';
import '../../services/logger_service.dart';
import 'map_state.dart';

const openFreeMapBrightVector = 'https://tiles.openfreemap.org/styles/bright';

final mapHasCenteredProvider = StateProvider.autoDispose<bool>(
  (_) => false,
);

final mapControllerProvider = Provider.autoDispose<MapController>(
  (ref) {
    final controller = MapController();
    ref.onDispose(controller.dispose);
    return controller;
  },
  name: 'MapControllerProvider',
);

final loadVectorMapsStyleProvider = FutureProvider<Style?>(
  (ref) async {
    try {
      final style = await StyleReader(
        uri: openFreeMapBrightVector,
      ).read();

      return style;
    } catch (e) {
      final error = 'Error in loadVectorMapsStyle()\n$e';
      ref.read(loggerProvider).e(error);
      return null;
    }
  },
  name: 'LoadVectorMapsStyleProvider',
);

final mapProvider = StateNotifierProvider.autoDispose<MapNotifier, MapState>(
  (ref) => MapNotifier(
    logger: ref.watch(loggerProvider),
  ),
  name: 'MapProvider',
);

class MapNotifier extends StateNotifier<MapState> {
  final LoggerService logger;
  Timer? timer;

  static const timelineHours = 72;

  MapNotifier({
    required this.logger,
  }) : super(
         const MapState(
           timeline: [],
           timelineIndex: 0,
           isPlaying: false,
           overlay: WeatherMapOverlayType.temperature,
         ),
       )
  ///
  /// INIT
  ///
  {
    state = MapState(
      timeline: generateTimeline(),
      timelineIndex: 0,
      isPlaying: false,
      overlay: WeatherMapOverlayType.temperature,
    );
  }

  ///
  /// DISPOSE
  ///

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  static List<DateTime> generateTimeline() {
    final now = DateTime.now().toUtc();

    final start = DateTime.utc(now.year, now.month, now.day, now.hour);

    return List<DateTime>.generate(
      timelineHours,
      (index) => start.add(
        Duration(
          hours: index,
        ),
      ),
      growable: false,
    );
  }

  void togglePlayback() => state.isPlaying ? pausePlayback() : startPlayback();

  void startPlayback() {
    if (state.timeline.isEmpty) {
      logger.e('Map playback requested but timeline is empty.');
      return;
    }

    timer?.cancel();
    timer = Timer.periodic(
      PromajaDurations.mapPlayback,
      (_) => advanceTimeline(),
    );

    state = state.copyWith(
      isPlaying: true,
    );
  }

  void pausePlayback() {
    stopTimer();
    state = state.copyWith(
      isPlaying: false,
    );
  }

  void setOverlay(WeatherMapOverlayType overlay) {
    if (state.overlay == overlay) {
      return;
    }
    state = state.copyWith(
      overlay: overlay,
    );
  }

  void setTimelineIndex(int index) {
    if (state.timeline.isEmpty) {
      return;
    }

    state = state.copyWith(
      timelineIndex: index.clamp(0, state.timeline.length - 1).toInt(),
    );
  }

  void regenerateTimeline() {
    final newTimeline = generateTimeline();

    state = state.copyWith(
      timeline: newTimeline,
      timelineIndex: state.timelineIndex.clamp(0, newTimeline.length - 1).toInt(),
    );
  }

  void advanceTimeline() {
    if (state.timeline.isEmpty) {
      pausePlayback();
      return;
    }

    final nextIndex = state.timelineIndex + 1;

    state = state.copyWith(
      timelineIndex: nextIndex >= state.timeline.length ? 0 : nextIndex,
    );
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }
}
