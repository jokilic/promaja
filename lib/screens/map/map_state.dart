import '../../models/map/weather_map_overlay_style.dart';

class MapState {
  final List<DateTime> timeline;
  final int timelineIndex;
  final bool isPlaying;
  final WeatherMapOverlayType overlay;

  const MapState({
    required this.timeline,
    required this.timelineIndex,
    required this.isPlaying,
    required this.overlay,
  });

  DateTime get selectedTimeUtc {
    if (timeline.isEmpty) {
      return DateTime.now().toUtc();
    }

    if (timelineIndex < 0) {
      return timeline.first;
    }

    if (timelineIndex >= timeline.length) {
      return timeline.last;
    }

    return timeline[timelineIndex];
  }

  MapState copyWith({
    List<DateTime>? timeline,
    int? timelineIndex,
    bool? isPlaying,
    WeatherMapOverlayType? overlay,
  }) => MapState(
    timeline: timeline ?? this.timeline,
    timelineIndex: timelineIndex ?? this.timelineIndex,
    isPlaying: isPlaying ?? this.isPlaying,
    overlay: overlay ?? this.overlay,
  );
}
