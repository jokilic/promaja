import 'package:easy_localization/easy_localization.dart';

import '../models/error/response_error.dart';
import '../models/location/location.dart';

String getErrorDescription({required int errorCode}) => errorCode == 0 ? 'weirdErrorHappened'.tr() : '${errorCode}Error'.tr();

String? getErrorText(({ResponseError? error, String? genericError, bool loading, List<Location>? response}) state) {
  /// Response is empty, there is no locations
  if (state.response?.isEmpty ?? false) {
    return 'noLocationsFound'.tr();
  }

  /// Some error happened
  if (state.error != null || state.genericError != null) {
    return state.error?.error.message ?? state.genericError ?? 'weirdErrorHappened'.tr();
  }

  /// No error happened
  return null;
}
