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
        VStack(spacing: 0) {
            Spacer()
            
            // Game Over Content
            VStack(spacing: 24) {
                // Game Over Title
                VStack(spacing: 8) {
                    Text("Game Over!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Final Score: \(gameManager.currentScore)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
                
                // High Score Celebration
                if isNewHighScore {
                    VStack(spacing: 12) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.yellow)
                        
                        Text("New High Score! 🎉")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }
                    .padding(.vertical, 20)
                }
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 12) {
                Button(action: {
                    HapticManager.shared.softHaptic()
                    gameManager.resetGame()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("Back to Menu")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    HapticManager.shared.lightHaptic()
                    gameManager.startGame(mode: gameManager.gameMode)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("Play Again")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.green, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
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