//
//  ContentView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameCenterManager: GameCenterManager
    
    var body: some View {
        MainMenuView()
            .environmentObject(gameCenterManager)
    }
}

#Preview {
    ContentView()
        .environmentObject(GameCenterManager.shared)
}
