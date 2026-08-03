//
//  ClipApp.swift
//  Clip
//
//  Created by 戴培琼 on 2026/7/2.
//

import SwiftUI

@main
struct ClipApp: App {
    @UIApplicationDelegateAdaptor(ClipAppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ClipContentView()
                .tint(.blue)
        }
    }
}
