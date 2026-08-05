import SwiftUI
import UIKit

/// Shared so AppDelegate can deliver warm-start invocations reliably.
final class ClipInvocationStore: ObservableObject {
    static let shared = ClipInvocationStore()

    @Published private(set) var url: URL?
    /// Bumps on every invocation so the UI re-opens even for the same URL.
    @Published private(set) var invocationEpoch: UInt = 0

    func receive(_ url: URL, source: String) {
        print("🟢 [Clip] Received URL (\(source)): \(url.absoluteString)")
        print("🟢 [Clip] bundleId=\(Bundle.main.bundleIdentifier ?? "nil")")
        self.url = url
        invocationEpoch &+= 1
    }
}

final class ClipAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if let activity = launchOptions?[.userActivityDictionary] as? [AnyHashable: Any] {
            for value in activity.values {
                if let userActivity = value as? NSUserActivity {
                    deliver(userActivity, source: "launchOptions")
                }
            }
        }
        return true
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        deliver(userActivity, source: "appDelegate.continue")
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        for activity in options.userActivities {
            deliver(activity, source: "sceneConnection")
        }
        if let activity = connectingSceneSession.stateRestorationActivity {
            deliver(activity, source: "stateRestoration")
        }
        return UISceneConfiguration(
            name: nil,
            sessionRole: connectingSceneSession.role
        )
    }

    @discardableResult
    private func deliver(_ activity: NSUserActivity, source: String) -> Bool {
        guard activity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = activity.webpageURL else {
            return false
        }
        ClipInvocationStore.shared.receive(url, source: source)
        return true
    }
}

// MARK: - Root View
struct ClipContentView: View {
    @ObservedObject private var store = ClipInvocationStore.shared
    @Environment(\.scenePhase) private var scenePhase

    @State private var openError: String?
    @State private var lastOpenedEpoch: UInt = 0
    @State private var lastOpenAttemptAt: Date?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "safari")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            if let url = store.url {
                Text("Opening browser…")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Text(url.absoluteString)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                if let openError {
                    Text(openError)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Button {
                    openInBrowser(url, reason: "button")
                } label: {
                    Label("Open in Browser", systemImage: "safari")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
            } else {
                Text("Waiting for link...")
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
            guard let url = activity.webpageURL else { return }
            store.receive(url, source: "userActivity")
        }
        .onOpenURL { url in
            store.receive(url, source: "onOpenURL")
        }
        .onAppear {
            if let raw = ProcessInfo.processInfo.environment["_XCAppClipURL"],
               let url = URL(string: raw) {
                store.receive(url, source: "_XCAppClipURL")
            }
            openLatestIfNeeded(reason: "onAppear")
        }
        .onChange(of: store.invocationEpoch) { _ in
            openLatestIfNeeded(reason: "invocationEpoch")
        }
        .onChange(of: scenePhase) { phase in
            // Warm App Clip: card "Open" resumes process; URL may already be in store.
            if phase == .active {
                openLatestIfNeeded(reason: "sceneActive")
            }
        }
    }

    private func openLatestIfNeeded(reason: String) {
        guard let url = store.url else { return }

        // Fresh invocation (new card tap / continue activity).
        if store.invocationEpoch != lastOpenedEpoch {
            handOffToAppOrBrowser(url, reason: reason)
            return
        }

        // Warm App Clip: second "Open" may only resume the process without a new
        // activity. Re-open after a short cooldown so returning from Safari within
        // ~2s does not immediately loop, but a later card tap still works.
        if reason == "sceneActive" {
            let now = Date()
            if let last = lastOpenAttemptAt, now.timeIntervalSince(last) < 2.0 {
                print("🟡 [Clip] Skip sceneActive reopen (cooldown)")
                return
            }
            handOffToAppOrBrowser(url, reason: reason)
        }
    }

    /// Prefer full ChipBase app (chipbase://) when installed; else Safari.
    private func handOffToAppOrBrowser(_ url: URL, reason: String) {
        let now = Date()
        if let last = lastOpenAttemptAt,
           store.invocationEpoch == lastOpenedEpoch,
           now.timeIntervalSince(last) < 1.2,
           reason != "button" {
            print("🟡 [Clip] Skip duplicate handoff (\(reason))")
            return
        }

        lastOpenedEpoch = store.invocationEpoch
        lastOpenAttemptAt = now
        openError = nil

        if let appURL = makeFullAppHandoffURL(ndef: url),
           UIApplication.shared.canOpenURL(appURL) {
            print("🟢 [Clip] Hand off to full app (\(reason)): \(appURL.absoluteString)")
            UIApplication.shared.open(appURL, options: [:]) { success in
                DispatchQueue.main.async {
                    if success {
                        print("🟢 [Clip] Full app opened")
                    } else {
                        print("🟡 [Clip] Full app open failed — fallback Safari")
                        self.openInBrowser(url, reason: "\(reason)-fallback")
                    }
                }
            }
            return
        }

        openInBrowser(url, reason: reason)
    }

    private func makeFullAppHandoffURL(ndef: URL) -> URL? {
        var components = URLComponents()
        components.scheme = "chipbase"
        components.host = "ndef"
        components.queryItems = [URLQueryItem(name: "url", value: ndef.absoluteString)]
        return components.url
    }

    private func openInBrowser(_ url: URL, reason: String) {
        // Debounce already applied in handOff; button can call this directly.
        if reason == "button" {
            let now = Date()
            lastOpenedEpoch = store.invocationEpoch
            lastOpenAttemptAt = now
            openError = nil
        }
        print("🟢 [Clip] Opening browser (\(reason)): \(url.absoluteString)")

        UIApplication.shared.open(url, options: [:]) { success in
            DispatchQueue.main.async {
                if success {
                    print("🟢 [Clip] Opened browser OK")
                } else {
                    openError = "Could not open browser. Tap below to retry."
                    print("🔴 [Clip] Failed to open browser")
                }
            }
        }
    }
}
