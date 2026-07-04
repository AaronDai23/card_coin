import SwiftUI

// MARK: - Root View
struct ClipContentView: View {
    @State private var incomingURL: URL? = nil

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "link.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            if let url = incomingURL {
                Text(url.absoluteString)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Link(destination: url) {
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
            print("🟢 [Clip] Received URL: \(url.absoluteString)")
            
            print(Bundle.main.bundleIdentifier)
            incomingURL = url
        }
    }
}

