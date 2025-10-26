import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../constants/colors.dart';
import '../../constants/durations.dart';
import '../../models/map/weather_map_overlay_style.dart';
import '../../services/hive_service.dart';
import '../../widgets/promaja_navigation_bar.dart';
import 'map_notifiers.dart';
import 'widgets/map_marker.dart';

class MapScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();

    final hasCentered = ref.read(mapHasCenteredProvider);
    final locations = ref.read(hiveProvider);

    if (!hasCentered && locations.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mapHasCenteredProvider.notifier).state = true;
        ref
            .read(mapProvider.notifier)
            .fitToLocations(
              controller: ref.read(mapControllerProvider),
              locations: locations,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(hiveProvider);
    final mapState = ref.watch(mapProvider);
    final mapController = ref.watch(mapControllerProvider);

    final mapNotifier = ref.read(mapProvider.notifier);

    final markers = locations
        .map(
          (location) => Marker(
            point: LatLng(
              location.lat,
              location.lon,
            ),
            height: 24,
            width: 24,
            alignment: Alignment.topCenter,
            child: MapMarker(
              location: location,
            ),
          ),
        )
        .toList();

    final overlayTemplate = mapNotifier.overlayUrlTemplate(
      state: mapState,
    );
    final selectedTime = mapState.selectedTimeUtc.toLocal();

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: PromajaNavigationBar(),
      body: Animate(
        key: ValueKey(ref.read(navigationBarIndexProvider)),
        effects: [
          FadeEffect(
            curve: Curves.easeIn,
            duration: PromajaDurations.fadeAnimation,
          ),
        ],
        child: ref
            .watch(loadVectorMapsStyleProvider)
            .when(
              data: (mapStyle) {
                ///
                /// STYLE SUCCESSFULLY LOADED
                ///
                if (mapStyle != null) {
                  return Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: mapNotifier.initialCenter(
                            locations: locations,
                          ),
                          initialZoom: locations.isNotEmpty ? 6 : 4,
                          minZoom: 2,
                          maxZoom: 16,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                          ),
                          backgroundColor: PromajaColors.black,
                        ),
                        children: [
                          ///
                          /// MAP VECTOR
                          ///
                          VectorTileLayer(
                            tileProviders: mapStyle.providers,
                            theme: mapStyle.theme,
                            sprites: mapStyle.sprites,
                            maximumZoom: 16,
                            tileOffset: TileOffset.mapbox,
                          ),

                          ///
                          /// OVERLAY
                          ///
                          if (overlayTemplate != null)
                            TileLayer(
                              key: ValueKey(
                                '${mapState.overlay.name}_${mapState.selectedTimeUtc.toIso8601String()}',
                              ),
                              urlTemplate: overlayTemplate,
                              userAgentPackageName: 'com.promaja.app',
                              tileBuilder: (context, tileWidget, tile) => Opacity(
                                opacity: 0.65,
                                child: tileWidget,
                              ),
                            ),

                          ///
                          /// LOCATIONS
                          ///
                          if (markers.isNotEmpty)
                            MarkerLayer(
                              markers: markers,
                            ),
                        ],
                      ),

                      // TODO: Widget
                      if (locations.isEmpty)
                        Container(
                          color: Colors.pink,
                        ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: _OverlaySelector(
                                  selectedOverlay: mapState.overlay,
                                  onOverlayChanged: mapNotifier.setOverlay,
                                ),
                              ),
                              _TimelineControls(
                                isPlaying: mapState.isPlaying,
                                timelineLength: mapState.timeline.length,
                                currentIndex: mapState.timelineIndex,
                                currentTime: selectedTime,
                                onPlayPausePressed: mapNotifier.togglePlayback,
                                onSliderChangeStart: mapNotifier.pausePlayback,
                                onSliderChanged: (value) => mapNotifier.setTimelineIndex(value.round()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                ///
                /// ERROR WHILE LOADING
                ///
                // TODO: Error widget
                return Container(
                  color: Colors.red,
                );
              },
              // TODO: Error widget
              error: (error, stackTrace) => Container(
                color: Colors.amber,
              ),
              // TODO: Loading widget
              loading: () => Container(
                color: Colors.blue,
              ),
            ),
      ),
    );
  }
}

class _OverlaySelector extends StatelessWidget {
  final WeatherMapOverlayType selectedOverlay;
  final ValueChanged<WeatherMapOverlayType> onOverlayChanged;

  const _OverlaySelector({
    required this.selectedOverlay,
    required this.onOverlayChanged,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: PromajaColors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: PromajaColors.white.withValues(alpha: 0.2),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: WeatherMapOverlayType.values
            .map(
              (overlay) => ChoiceChip(
                label: Text(
                  getTileLabel(overlay),
                  style: const TextStyle(
                    color: PromajaColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: selectedOverlay == overlay,
                selectedColor: PromajaColors.indigo,
                backgroundColor: PromajaColors.black.withValues(alpha: 0.4),
                showCheckmark: false,
                onSelected: (_) => onOverlayChanged(overlay),
              ),
            )
            .toList(),
      ),
    ),
  );
}

class _TimelineControls extends StatelessWidget {
  final bool isPlaying;
  final int timelineLength;
  final int currentIndex;
  final DateTime currentTime;
  final VoidCallback onPlayPausePressed;
  final VoidCallback onSliderChangeStart;
  final ValueChanged<double> onSliderChanged;

  const _TimelineControls({
    required this.isPlaying,
    required this.timelineLength,
    required this.currentIndex,
    required this.currentTime,
    required this.onPlayPausePressed,
    required this.onSliderChangeStart,
    required this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sliderMax = timelineLength > 1 ? (timelineLength - 1).toDouble() : 1.0;
    final hasTimeline = timelineLength > 0;
    final sliderValue = hasTimeline ? currentIndex.clamp(0, sliderMax.toInt()).toDouble() : 0.0;
    final formattedTime = DateFormat('EEE, MMM d • HH:mm').format(currentTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: PromajaColors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PromajaColors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _PlayPauseButton(
                isPlaying: isPlaying,
                onPressed: onPlayPausePressed,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: PromajaColors.white,
                    inactiveTrackColor: PromajaColors.white.withValues(alpha: 0.2),
                    thumbColor: PromajaColors.white,
                    overlayColor: PromajaColors.white.withValues(alpha: 0.1),
                  ),
                  child: Slider(
                    value: sliderValue,
                    max: sliderMax,
                    divisions: hasTimeline && timelineLength > 1 ? timelineLength - 1 : null,
                    onChanged: hasTimeline ? onSliderChanged : null,
                    onChangeStart: hasTimeline ? (_) => onSliderChangeStart() : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formattedTime,
              style: const TextStyle(
                color: PromajaColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      color: isPlaying ? PromajaColors.indigo : PromajaColors.black.withValues(alpha: 0.7),
      shape: BoxShape.circle,
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(
        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: PromajaColors.white,
        size: 24,
      ),
      splashRadius: 28,
    ),
  );
}
