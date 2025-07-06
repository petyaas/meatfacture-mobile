import UIKit
import Flutter
import YandexMapsMobile


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
// Your preferred language. Not required, defaults to system language
    YMKMapKit.setApiKey("3ae955c6-35da-4f43-8e13-6f14f16dadd9")
    GeneratedPluginRegistrant.register(with: self)
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if error != nil {
        }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}

