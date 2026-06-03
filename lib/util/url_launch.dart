import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';

void openUrlExternalBrowser(BuildContext context, {required String? url}) {
  if (url != null) {
    /// Parse `URL`
    final uri = Uri.tryParse(url);

    /// `URL` has errors parsing
    if (uri == null) {
      return;
    }

    /// Use `url_launcher` if not Android / iOS
    if (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS) {
      launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      return;
    }

    /// Use external browser
    FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: const CustomTabsOptions(
        defaultColorSchemeParams: CustomTabsColorSchemeParams(
          toolbarColor: PromajaColors.black,
          navigationBarColor: PromajaColors.black,
          secondaryToolbarColor: PromajaColors.black,
          navigationBarDividerColor: PromajaColors.black,
        ),
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: PromajaColors.black,
        preferredControlTintColor: PromajaColors.white,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }
}
