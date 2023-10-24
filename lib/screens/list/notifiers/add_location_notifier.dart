import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/location/location.dart';
import '../../../services/api_service.dart';
import '../../../services/hive_service.dart';

final addLocationProvider = StateNotifierProvider<AddLocationController, ({List<Location>? response, String? error, bool loading})>(
  (ref) {
    final addLocationController = AddLocationController(
      hiveService: ref.watch(hiveProvider.notifier),
      ref: ref,
    );
    ref.onDispose(addLocationController.dispose);

    return addLocationController;
  },
  name: 'AddLocationProvider',
);

final getSearchProvider = FutureProvider.family<({List<Location>? response, String? error}), String>(
  (ref, query) async => ref.read(apiProvider).getSearch(query: query),
  name: 'GetSearchProvider',
);

class AddLocationController extends StateNotifier<({List<Location>? response, String? error, bool loading})> {
  final HiveService hiveService;
  final Ref ref;

  AddLocationController({
    required this.hiveService,
    required this.ref,
  }) : super((
          response: null,
          error: null,
          loading: false,
        ));

  /// Limiting locations because of free API
  final locationLimit = 5;

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  late final textEditingController = TextEditingController();
  late final scrollController = ScrollController();

  Future<void> searchPlace(String value) async {
    if (value.isNotEmpty) {
      state = (
        response: null,
        error: null,
        loading: true,
      );

      final response = await ref.read(getSearchProvider(value).future);

      state = (
        response: response.response,
        error: response.error,
        loading: false,
      );

      if (scrollController.positions.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => scrollController.animateTo(
            scrollController.positions.last.maxScrollExtent,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          ),
        );
      }
    }
  }

  Future<void> addPlace({required Location location}) async {
    textEditingController.clear();

    /// If user has more than `locationLimit` locations, throw error
    if (ref.read(hiveProvider).length >= locationLimit) {
      state = (
        response: null,
        error: "You can't have more than $locationLimit locations",
        loading: false,
      );
      return;
    }

    /// Check if location already exists
    final locationExists = ref.read(hiveProvider).contains(location);

    /// Location already exists, throw error
    if (locationExists) {
      state = (
        response: null,
        error: '${location.name}, ${location.country} already exists.',
        loading: false,
      );
      return;
    }

    ///
    /// Add location
    ///
    if (!locationExists) {
      await hiveService.addLocationToBox(
        location: location,
        index: ref.read(hiveProvider).length,
      );

      state = (
        response: null,
        error: null,
        loading: false,
      );

      /// Scroll to the bottom
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => scrollController.animateTo(
          scrollController.positions.last.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        ),
      );
    }
  }
}
