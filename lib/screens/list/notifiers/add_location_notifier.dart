import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/durations.dart';
import '../../../models/error/response_error.dart';
import '../../../models/location/location.dart';
import '../../../services/api_service.dart';
import '../../../services/hive_service.dart';
import '../../../services/logger_service.dart';

final addLocationProvider = NotifierProvider<AddLocationNotifier, ({List<Location>? response, ResponseError? error, String? genericError, bool loading})>(
  AddLocationNotifier.new,
  name: 'AddLocationProvider',
);

final getSearchProvider = FutureProvider.family<({List<Location>? response, ResponseError? error, String? genericError}), String>(
  (ref, query) async => ref.read(apiProvider).getSearch(query: query),
  name: 'GetSearchProvider',
);

class AddLocationNotifier extends Notifier<({List<Location>? response, ResponseError? error, String? genericError, bool loading})> {
  late final logger = ref.read(loggerProvider);
  late final hiveService = ref.read(hiveProvider.notifier);

  ///
  /// INIT
  ///

  @override
  ({
    List<Location>? response,
    ResponseError? error,
    String? genericError,
    bool loading,
  })
  build() {
    ref.onDispose(() {
      scrollController.dispose();
      textEditingController.dispose();
    });

    return (
      response: null,
      error: null,
      genericError: null,
      loading: false,
    );
  }

  ///
  /// VARIABLES
  ///

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
    }
  }

  /// Checks location limit is met or if place exists
  /// Adds place in `Hive`
  Future<void> addPlace({required Location location}) async {
    textEditingController.clear();

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
      if (scrollController.positions.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => scrollController.animateTo(
            scrollController.positions.last.maxScrollExtent,
            duration: PromajaDurations.scrollAnimation,
            curve: Curves.fastOutSlowIn,
          ),
        );
      }
    }
  }
}
