//
//  SplashView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var showMainMenu = false
    
    var body: some View {
        Group {
            if showMainMenu {
                ContentView()
                    .transition(.opacity)
            } else {
                ZStack {
                    // Background that respects light/dark mode
                    Color(uiColor: .systemBackground)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 24) {
                        // Logo with spinning animation
                        Image("TrueHue")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .animation(
                                .linear(duration: 1.5)
                                .repeatCount(2, autoreverses: false),
                                value: isAnimating
                            )
                        
                        // App title
                        Text("TrueHue")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeInOut(duration: 0.8).delay(0.3), value: isAnimating)
                        
                        // Subtitle
                        Text("Color Matching Puzzle")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeInOut(duration: 0.8).delay(0.5), value: isAnimating)
                    }
                }
            }
        }
        .onAppear {
            // Start animations
            withAnimation {
                isAnimating = true
            }
            
            // Transition to main menu after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showMainMenu = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
