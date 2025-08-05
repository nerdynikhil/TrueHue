//
//  GameOverView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var gameManager: GameManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Liquid Glass Background
            LiquidGlassBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Game Over Title with Liquid Glass
                VStack(spacing: 20) {
                    Text("Game Over!")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.ultraThinMaterial)
                                .blur(radius: 0.5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(.quaternary, lineWidth: 0.5)
                                )
                        )
                    
                    Text("Final Score: \(gameManager.currentScore)")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .blur(radius: 0.5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.quaternary, lineWidth: 0.5)
                                )
                        )
                }
                
                // High Score Celebration with Liquid Glass
                if isNewHighScore {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 80, height: 80)
                                .blur(radius: 0.5)
                            
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.yellow)
                        }
                        
                        Text("New High Score! 🎉")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .blur(radius: 0.5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.quaternary, lineWidth: 0.5)
                                    )
                            )
                    }
                    .padding(.vertical, 20)
                }
                
                Spacer()
                
                // Action Buttons with Liquid Glass
                VStack(spacing: 20) {
                    LiquidGlassActionButton(
                        title: "Back to Menu",
                        icon: "house.fill",
                        color: .blue
                    ) {
                        gameManager.resetGame()
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    LiquidGlassActionButton(
                        title: "Play Again",
                        icon: "arrow.clockwise",
                        color: .green
                    ) {
                        gameManager.startGame(mode: gameManager.gameMode)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
    
    private var isNewHighScore: Bool {
        guard let currentHighScore = gameManager.highScores[gameManager.gameMode] else {
            return true
        }
        return gameManager.currentScore > currentHighScore
    }
}

#Preview {
    GameOverView()
        .environmentObject(GameManager())
} 