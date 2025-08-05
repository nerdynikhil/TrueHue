//
//  ContentView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            MainMenuView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
