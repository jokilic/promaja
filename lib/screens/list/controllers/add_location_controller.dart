import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../constants/durations.dart';
import '../../../constants/typedefs.dart';
import '../../../models/location/location.dart';
import '../../../services/api_service.dart';
import '../../../services/hive_service.dart';

class AddLocationController extends ValueNotifier<({SearchResult searchResult, bool loading})> implements Disposable {
  final HiveService hive;
  final APIService api;

  AddLocationController({
    required this.hive,
    required this.api,
  }) : super((
         searchResult: (
           response: null,
           error: null,
           genericError: null,
         ),
         loading: false,
       ));

  ///
  /// DISPOSE
  ///

  @override
  void onDispose() {
    scrollController.dispose();
    textEditingController.dispose();
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
  Future<void> searchPlace(String passedValue) async {
    if (passedValue.isNotEmpty) {
      value = (
        searchResult: (
          response: null,
          error: null,
          genericError: null,
        ),
        loading: true,
      );

      final response = await api.getSearch(
        query: passedValue.trim(),
      );

      value = (
        searchResult: (
          response: response.response,
          error: response.error,
          genericError: response.genericError,
        ),
        loading: false,
      );
    }
  }

  /// Checks if place exists
  /// Adds place in `Hive`
  Future<void> addPlace({required Location location}) async {
    /// Clear [TextField]
    textEditingController.clear();

    /// Get currently stored `locations`
    final locations = hive.getLocationsFromBox();

    /// Check if location already exists
    final locationExists = locations.contains(location);

    /// Location already exists, throw error
    if (locationExists) {
      value = (
        searchResult: (
          response: null,
          error: null,
          genericError: 'locationAlreadyExists'.tr(
            args: [location.name, location.country],
          ),
        ),
        loading: false,
      );

      return;
    }

    ///
    /// Add location
    ///
    if (!locationExists) {
      await hive.addLocationToBox(
        location: location,
        index: locations.length,
      );

      value = (
        searchResult: (
          response: null,
          error: null,
          genericError: null,
        ),
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
