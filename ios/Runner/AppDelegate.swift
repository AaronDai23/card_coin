import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let eventsChannelName = "com.walletconnect.flutterwallet/events"
  private let methodsChannelName = "com.walletconnect.flutterwallet/methods"

  private var eventSink: FlutterEventSink?
  private var initialLink: String?
  private var channelsRegistered = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ChipCoreSdkPlugin 作为 Flutter 插件，由 GeneratedPluginRegistrant 自动注册，
    // 无需在此手动调用 ChipCoreBlockchainApi.register。
    GeneratedPluginRegistrant.register(with: self)

    if let url = launchOptions?[.url] as? URL {
      initialLink = url.absoluteString
    }

    // 与 Android configureFlutterEngine 对齐：在 Dart main 跑起来之前注册 WC channel，
    // 避免 DeepLinkHandler.initListener 触发 MissingPluginException。
    registerWalletConnectChannelsIfNeeded()

    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    // super 后 window 就绪，若此前 registrar 不可用则补注册一次
    registerWalletConnectChannelsIfNeeded()
    return result
  }

  private func registerWalletConnectChannelsIfNeeded() {
    guard !channelsRegistered else { return }

    let messenger: FlutterBinaryMessenger?
    if let registrar = self.registrar(forPlugin: "WalletConnectLinkChannels") {
      messenger = registrar.messenger()
    } else if let controller = window?.rootViewController as? FlutterViewController {
      messenger = controller.binaryMessenger
    } else {
      DispatchQueue.main.async { [weak self] in
        self?.registerWalletConnectChannelsIfNeeded()
      }
      return
    }

    guard let messenger else { return }
    channelsRegistered = true

    FlutterEventChannel(name: eventsChannelName, binaryMessenger: messenger)
      .setStreamHandler(WalletConnectLinkStreamHandler { [weak self] sink in
        self?.eventSink = sink
      } onCancel: { [weak self] in
        self?.eventSink = nil
      })

    FlutterMethodChannel(name: methodsChannelName, binaryMessenger: messenger)
      .setMethodCallHandler { [weak self] call, result in
        if call.method == "initialLink" {
          // null 也必须回调，否则 Dart 侧会挂起（与 Android 一致）
          result(self?.initialLink)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    let link = url.absoluteString
    if initialLink == nil {
      initialLink = link
    }
    if url.scheme?.contains("wc") == true {
      eventSink?(link)
    }
    return super.application(app, open: url, options: options)
  }

  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      let link = url.absoluteString
      if initialLink == nil {
        initialLink = link
      }
      eventSink?(link)
    }
    return super.application(
      application,
      continue: userActivity,
      restorationHandler: restorationHandler
    )
  }
}

private final class WalletConnectLinkStreamHandler: NSObject, FlutterStreamHandler {
  private let onListen: (FlutterEventSink?) -> Void
  private let onCancel: () -> Void

  init(onListen: @escaping (FlutterEventSink?) -> Void, onCancel: @escaping () -> Void) {
    self.onListen = onListen
    self.onCancel = onCancel
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    onListen(events)
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    onCancel()
    return nil
  }
}
