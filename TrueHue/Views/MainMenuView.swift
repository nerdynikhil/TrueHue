//
//  MainMenuView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 40) {
            // App Title
            VStack(spacing: 8) {
                Text("TrueHue")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Color Matching Puzzle")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Game Mode Buttons
            VStack(spacing: 20) {
                GameModeButton(
                    title: "Classic Mode",
                    subtitle: "Match colors until you make a mistake",
                    icon: "gamecontroller.fill",
                    color: .blue
                ) {
                    gameManager.startGame(mode: .classic)
                }
                
                GameModeButton(
                    title: "Chrono Mode",
                    subtitle: "30 seconds to match as many as possible",
                    icon: "timer",
                    color: .orange
                ) {
                    gameManager.startGame(mode: .chrono)
                }
                
                GameModeButton(
                    title: "Find Color Mode",
                    subtitle: "Tap the correct color from a grid",
                    icon: "square.grid.3x3.fill",
                    color: .green
                ) {
                    gameManager.startGame(mode: .findColor)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // High Scores
            VStack(spacing: 12) {
                Text("High Scores")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                HStack(spacing: 30) {
                    HighScoreCard(mode: "Classic", score: gameManager.highScores[.classic] ?? 0)
                    HighScoreCard(mode: "Chrono", score: gameManager.highScores[.chrono] ?? 0)
                    HighScoreCard(mode: "Find", score: gameManager.highScores[.findColor] ?? 0)
                }
            }
            .padding(.bottom, 40)
        }
        .background(
            NavigationLink(
                destination: destinationView,
                isActive: Binding(
                    get: { gameManager.gameState == .playing },
                    set: { _ in }
                )
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
        case .chrono:
            ChronoModeView()
        case .findColor:
            FindColorModeView()
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
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HighScoreCard: View {
    let mode: String
    let score: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text(mode)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            
            Text("\(score)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
        }
        .frame(width: 80, height: 60)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    MainMenuView()
} 