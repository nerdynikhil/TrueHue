//
//  GameOverView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var gameCenterManager: GameCenterManager
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
                
                // Achievement Unlocks
                if let newAchievements = getNewAchievements(), !newAchievements.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.yellow)
                        
                        Text("Achievement Unlocked! ⭐")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        ForEach(newAchievements, id: \.type) { achievement in
                            Text(achievement.type.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                        }
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
    
    private func getNewAchievements() -> [Achievement]? {
        // Check for newly unlocked achievements based on current score
        let currentScore = gameManager.currentScore
        let mode = gameManager.gameMode
        
        var newAchievements: [Achievement] = []
        
        // Check score-based achievements
        if currentScore >= 10 {
            if let achievement = gameCenterManager.achievements.first(where: { $0.type == .score10 && !$0.isUnlocked }) {
                newAchievements.append(achievement)
            }
        }
        if currentScore >= 25 {
            if let achievement = gameCenterManager.achievements.first(where: { $0.type == .score25 && !$0.isUnlocked }) {
                newAchievements.append(achievement)
            }
        }
        if currentScore >= 50 {
            if let achievement = gameCenterManager.achievements.first(where: { $0.type == .score50 && !$0.isUnlocked }) {
                newAchievements.append(achievement)
            }
        }
        
        // Check mode-specific achievements
        switch mode {
        case .classic:
            if currentScore >= 5 {
                if let achievement = gameCenterManager.achievements.first(where: { $0.type == .classicMaster && !$0.isUnlocked }) {
                    newAchievements.append(achievement)
                }
            }
        case .chrono:
            if currentScore >= 15 {
                if let achievement = gameCenterManager.achievements.first(where: { $0.type == .chronoMaster && !$0.isUnlocked }) {
                    newAchievements.append(achievement)
                }
            }
        case .findColor:
            if currentScore >= 20 {
                if let achievement = gameCenterManager.achievements.first(where: { $0.type == .findColorMaster && !$0.isUnlocked }) {
                    newAchievements.append(achievement)
                }
            }
        }
        
        return newAchievements.isEmpty ? nil : newAchievements
    }
}

#Preview {
    GameOverView()
        .environmentObject(GameManager())
        .environmentObject(GameCenterManager.shared)
} 