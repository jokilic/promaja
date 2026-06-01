import 'package:easy_localization/easy_localization.dart';

import '../constants/typedefs.dart';

String getErrorDescription({required int errorCode}) => errorCode == 0 ? 'weirdErrorHappened'.tr() : '${errorCode}Error'.tr();

String? getErrorText(({SearchResult searchResult, bool loading}) state) {
  /// Response is empty, there is no locations
  if (state.searchResult.response?.isEmpty ?? false) {
    return 'noLocationsFound'.tr();
  }

  /// Some error happened
  if (state.searchResult.error != null || state.searchResult.genericError != null) {
    return state.searchResult.error?.error.message ?? state.searchResult.genericError ?? 'weirdErrorHappened'.tr();
  }

  /// No error happened
  return null;
}
