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
        VStack(spacing: 40) {
            Spacer()
            
            // Game Over Title
            VStack(spacing: 16) {
                Text("Game Over!")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Final Score: \(gameManager.currentScore)")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            // High Score Celebration
            if isNewHighScore {
                VStack(spacing: 12) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.yellow)
                    
                    Text("New High Score! 🎉")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 20)
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 16) {
                Button(action: {
                    gameManager.resetGame()
                    // Navigate back to root
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("Back to Menu")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Button(action: {
                    gameManager.startGame(mode: gameManager.gameMode)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("Play Again")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
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