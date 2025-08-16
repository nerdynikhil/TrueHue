//
//  TrueHueApp.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

@main
struct TrueHueApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
                .onAppear {
                    // Prepare haptics for better performance
                    HapticManager.shared.prepareHaptics()
                }
        }
    }
}
