import 'package:easy_localization/easy_localization.dart';

String getErrorDescription({required int errorCode}) => errorCode == 0 ? 'weirdErrorHappened'.tr() : '${errorCode}Error'.tr();
