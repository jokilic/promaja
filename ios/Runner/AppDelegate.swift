import UIKit
import Flutter
import flutter_local_notifications
import native_workmanager


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    if(!UserDefaults.standard.bool(forKey: "Notification")) {
      UIApplication.shared.cancelAllLocalNotifications()
      UserDefaults.standard.set(true, forKey: "Notification")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    handleEventsForBackgroundURLSession identifier: String,
    completionHandler: @escaping () -> Void
  ) {
     // Store completion handler in BackgroundSessionManager
    // The manager will call this when all transfers are done
    if identifier == "dev.brewkits.native_workmanager.background" {
      BackgroundSessionManager.shared.backgroundCompletionHandler = completionHandler
      NSLog("AppDelegate: Stored completion handler for background session")

      // Safety timeout: If BackgroundSessionManager doesn't call the handler within 30 seconds,
      // call it anyway to prevent iOS from terminating the app
      DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) { [weak self] in
        if BackgroundSessionManager.shared.backgroundCompletionHandler != nil {
          NSLog("AppDelegate: WARNING - Completion handler not called after 30s, calling now to prevent timeout")
          BackgroundSessionManager.shared.backgroundCompletionHandler?()
          BackgroundSessionManager.shared.backgroundCompletionHandler = nil
        }
      }
    } else {
      // Unknown session identifier - call completion handler immediately
      NSLog("AppDelegate: Warning - Unknown session identifier: \(identifier)")
      completionHandler()
    }

    if #available(iOS 13.0, *) {
      BackgroundSessionManager.shared.setBackgroundCompletionHandler(
        completionHandler,
        for: identifier
      )
    }
  }
}
