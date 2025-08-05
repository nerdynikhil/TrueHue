//
//  MainMenuView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject private var gameManager = GameManager()
    @State private var navigateToGame = false
    
    var body: some View {
        ZStack {
            // Liquid Glass Background
            LiquidGlassBackground()
            
            VStack(spacing: 40) {
                // App Title with Liquid Glass Effect
                VStack(spacing: 12) {
                    Text("TrueHue")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .blur(radius: 0.5)
                                .padding(.horizontal, -20)
                                .padding(.vertical, -8)
                        )
                    
                    Text("Color Matching Puzzle")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .blur(radius: 0.3)
                        )
                }
                .padding(.top, 80)
                
                Spacer()
                
                // Game Mode Buttons with Liquid Glass
                VStack(spacing: 24) {
                    LiquidGlassButton(
                        title: "Classic Mode",
                        subtitle: "Match colors until you make a mistake",
                        icon: "gamecontroller.fill",
                        color: .blue
                    ) {
                        gameManager.startGame(mode: .classic)
                        navigateToGame = true
                    }
                    
                    LiquidGlassButton(
                        title: "Chrono Mode",
                        subtitle: "30 seconds to match as many as possible",
                        icon: "timer",
                        color: .orange
                    ) {
                        gameManager.startGame(mode: .chrono)
                        navigateToGame = true
                    }
                    
                    LiquidGlassButton(
                        title: "Find Color Mode",
                        subtitle: "Tap the correct color from a grid",
                        icon: "square.grid.3x3.fill",
                        color: .green
                    ) {
                        gameManager.startGame(mode: .findColor)
                        navigateToGame = true
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // High Scores with Liquid Glass
                VStack(spacing: 16) {
                    Text("High Scores")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .blur(radius: 0.3)
                        )
                    
                    HStack(spacing: 20) {
                        LiquidGlassScoreCard(mode: "Classic", score: gameManager.highScores[.classic] ?? 0)
                        LiquidGlassScoreCard(mode: "Chrono", score: gameManager.highScores[.chrono] ?? 0)
                        LiquidGlassScoreCard(mode: "Find", score: gameManager.highScores[.findColor] ?? 0)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .background(
            NavigationLink(
                destination: destinationView,
                isActive: $navigateToGame
            ) {
                EmptyView()
            }
        )
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch gameManager.gameMode {
        case .classic:
            ClassicModeView()
                .environmentObject(gameManager)
        case .chrono:
            ChronoModeView()
                .environmentObject(gameManager)
        case .findColor:
            FindColorModeView()
                .environmentObject(gameManager)
        }
    }
}

#Preview {
    MainMenuView()
} 