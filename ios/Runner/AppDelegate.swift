import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ChipCoreSdkPlugin 作为 Flutter 插件，由 GeneratedPluginRegistrant 自动注册，
    // 无需在此手动调用 ChipCoreBlockchainApi.register。
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

