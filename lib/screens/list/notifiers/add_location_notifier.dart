import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/error/response_error.dart';
import '../../../models/location/location.dart';
import '../../../models/promaja_log/promaja_log_level.dart';
import '../../../services/api_service.dart';
import '../../../services/hive_service.dart';
import '../../../services/logger_service.dart';

final addLocationProvider = StateNotifierProvider<AddLocationNotifier, ({List<Location>? response, ResponseError? error, String? genericError, bool loading})>(
  (ref) {
    final addLocationController = AddLocationNotifier(
      logger: ref.watch(loggerProvider),
      hiveService: ref.watch(hiveProvider.notifier),
      ref: ref,
    );
    ref.onDispose(addLocationController.dispose);

    return addLocationController;
  },
  name: 'AddLocationProvider',
);

final getSearchProvider = FutureProvider.family<({List<Location>? response, ResponseError? error, String? genericError}), String>(
  (ref, query) async => ref.read(apiProvider).getSearch(query: query),
  name: 'GetSearchProvider',
);

class AddLocationNotifier extends StateNotifier<({List<Location>? response, ResponseError? error, String? genericError, bool loading})> {
  final LoggerService logger;
  final HiveService hiveService;
  final Ref ref;

  AddLocationNotifier({
    required this.logger,
    required this.hiveService,
    required this.ref,
  }) : super((
          response: null,
          error: null,
          genericError: null,
          loading: false,
        ));

  ///
  /// DISPOSE
  ///

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  ///
  /// VARIABLES
  ///

  /// Limiting locations because of free API
  final locationLimit = 5;

  late final textEditingController = TextEditingController();
  late final scrollController = ScrollController();

  ///
  /// METHODS
  ///

  /// Searches for a place and returns `List<Location>`
  Future<void> searchPlace(String value) async {
    if (value.isNotEmpty) {
      state = (
        response: null,
        error: null,
        genericError: null,
        loading: true,
      );

      final response = await ref.read(getSearchProvider(value).future);

      state = (
        response: response.response,
        error: response.error,
        genericError: response.genericError,
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

      hiveService.logPromajaEvent(
        text: 'searchPlace -> $value',
        logLevel: PromajaLogLevel.list,
      );
    }
  }

  /// Checks location limit is met or if place exists
  /// Adds place in `Hive`
  Future<void> addPlace({required Location location}) async {
    textEditingController.clear();

    /// If user has more than `locationLimit` locations, throw error
    if (ref.read(hiveProvider).length >= locationLimit) {
      state = (
        response: null,
        error: null,
        genericError: 'noMoreThanXLocations'.tr(
          args: ['$locationLimit'],
        ),
        loading: false,
      );

      hiveService.logPromajaEvent(
        text: 'addPlace -> locationLimit is triggered',
        logLevel: PromajaLogLevel.list,
        isError: true,
      );

      return;
    }

    /// Check if location already exists
    final locationExists = ref.read(hiveProvider).contains(location);

    /// Location already exists, throw error
    if (locationExists) {
      state = (
        response: null,
        error: null,
        genericError: 'locationAlreadyExists'.tr(
          args: [location.name, location.country],
        ),
        loading: false,
      );

      hiveService.logPromajaEvent(
        text: 'addPlace -> location exists',
        logLevel: PromajaLogLevel.list,
        isError: true,
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
        genericError: null,
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

      hiveService.logPromajaEvent(
        text: 'addPlace -> ${location.name}, ${location.country}',
        logLevel: PromajaLogLevel.list,
      );
    }
  }
}
