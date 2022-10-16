import 'package:alice/alice.dart';

///
/// This is used to initialize `Alice` and use it when necessary
/// Check more about `Alice` here: https://pub.dev/packages/alice
///

class AliceService {
  ///
  /// VARIABLES
  ///

  late final alice = Alice();

  ///
  /// METHODS
  ///

  /// Opens a screen with `Alice`
  void openAlice() => alice.showInspector();
}
