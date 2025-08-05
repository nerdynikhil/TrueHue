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
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // App Title Section
                    VStack(spacing: 8) {
                        Text("TrueHue")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("Color Matching Puzzle")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Game Mode Buttons
                    VStack(spacing: 12) {
                        GameModeButton(
                            title: "Classic Mode",
                            subtitle: "Match colors until you make a mistake",
                            icon: "gamecontroller.fill",
                            color: .blue
                        ) {
                            gameManager.startGame(mode: .classic)
                            navigateToGame = true
                        }
                        
                        GameModeButton(
                            title: "Chrono Mode",
                            subtitle: "30 seconds to match as many as possible",
                            icon: "timer",
                            color: .orange
                        ) {
                            gameManager.startGame(mode: .chrono)
                            navigateToGame = true
                        }
                        
                        GameModeButton(
                            title: "Find Color Mode",
                            subtitle: "Tap the correct color from a grid",
                            icon: "square.grid.3x3.fill",
                            color: .green
                        ) {
                            gameManager.startGame(mode: .findColor)
                            navigateToGame = true
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // High Scores Section
                    VStack(spacing: 16) {
                        Text("High Scores")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        
                        HStack(spacing: 16) {
                            HighScoreCard(mode: "Classic", score: gameManager.highScores[.classic] ?? 0)
                            HighScoreCard(mode: "Chrono", score: gameManager.highScores[.chrono] ?? 0)
                            HighScoreCard(mode: "Find", score: gameManager.highScores[.findColor] ?? 0)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                NavigationLink(
                    destination: destinationView,
                    isActive: $navigateToGame
                ) {
                    EmptyView()
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
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

struct GameModeButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon Container
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.quaternary, lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
    }
}

struct HighScoreCard: View {
    let mode: String
    let score: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text(mode)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text("\(score)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.quaternary, lineWidth: 0.5)
        )
    }
}

#Preview {
    MainMenuView()
} 