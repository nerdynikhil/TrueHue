//
//  GameManager.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI
import Foundation
import Combine

enum GameState {
    case menu
    case playing
    case gameOver
}

enum GameMode: String, Codable, CaseIterable {
    case classic
    case chrono
    case findColor
}

class GameManager: ObservableObject {
    // MARK: - Published Properties
    @Published var currentScore = 0
    @Published var gameState: GameState = .menu
    @Published var gameMode: GameMode = .classic
    @Published var currentColorName = ""
    @Published var currentDisplayColor = Color.blue
    @Published var isCorrectMatch = false
    
    // MARK: - Game Properties
    private let colors: [(name: String, color: Color)] = [
        ("Red", .red),
        ("Blue", .blue),
        ("Green", .green),
        ("Yellow", .yellow),
        ("Orange", .orange),
        ("Purple", .purple),
        ("Pink", .pink),
        ("Brown", .brown),
        ("Gray", .gray),
        ("Black", .black),
        ("White", .white),
        ("Cyan", .cyan),
        ("Indigo", .indigo),
        ("Teal", .teal)
    ]
    
    // MARK: - Timer Properties (for Chrono Mode)
    private var timer: Timer?
    @Published var timeRemaining = 30
    
    // MARK: - High Scores
    @Published var highScores: [GameMode: Int] = [:]
    
    init() {
        loadHighScores()
    }
    
    // MARK: - Game Lifecycle Methods
    func startGame(mode: GameMode) {
        gameMode = mode
        gameState = .playing
        currentScore = 0
        timeRemaining = 30
        
        if mode == .chrono {
            startTimer()
        }
        
        generateNewQuestion()
        
        // Light haptic for game start
        HapticManager.shared.lightHaptic()
    }
    
    func endGame() {
        gameState = .gameOver
        timer?.invalidate()
        timer = nil
        
        // Check for high score
        if let currentHighScore = highScores[gameMode] {
            if currentScore > currentHighScore {
                highScores[gameMode] = currentScore
                saveHighScores()
                // Light haptic for new high score
                HapticManager.shared.lightHaptic()
            }
        } else {
            highScores[gameMode] = currentScore
            saveHighScores()
            // Light haptic for first high score
            HapticManager.shared.lightHaptic()
        }
    }
    
    func resetGame() {
        gameState = .menu
        currentScore = 0
        timeRemaining = 30
        timer?.invalidate()
        timer = nil
        
        // Soft haptic for game reset
        HapticManager.shared.softHaptic()
    }
    
    // MARK: - Question Generation
    func generateNewQuestion() {
        let randomColorIndex = Int.random(in: 0..<colors.count)
        let randomDisplayIndex = Int.random(in: 0..<colors.count)
        
        currentColorName = colors[randomColorIndex].name
        currentDisplayColor = colors[randomDisplayIndex].color
        
        // Determine if the name and color match
        isCorrectMatch = randomColorIndex == randomDisplayIndex
    }
    
    // MARK: - Answer Checking
    func checkAnswer(userThinksMatch: Bool) -> Bool {
        let correct = userThinksMatch == isCorrectMatch
        
        if correct {
            currentScore += 1
            // Light haptic for correct answer
            HapticManager.shared.lightHaptic()
        } else {
            // Light haptic for incorrect answer
            HapticManager.shared.lightHaptic()
        }
        
        // For Classic Mode, end game on first mistake
        if gameMode == .classic && !correct {
            endGame()
        } else if gameMode == .classic && correct {
            generateNewQuestion()
        } else if gameMode == .chrono {
            generateNewQuestion()
        }
        // Find Color mode is handled in the view itself
        
        return correct
    }
    
    // MARK: - Find Color Mode Methods
    func generateFindColorQuestion() {
        let randomColorIndex = Int.random(in: 0..<colors.count)
        currentColorName = colors[randomColorIndex].name
        currentDisplayColor = colors[randomColorIndex].color
    }
    
    // MARK: - Timer Methods (for Chrono Mode)
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                // Light haptic when time runs out
                HapticManager.shared.lightHaptic()
                self.endGame()
            }
        }
    }
    
    // MARK: - High Score Management
    private func saveHighScores() {
        // Convert GameMode to String for JSON encoding
        var highScoresDict: [String: Int] = [:]
        for (mode, score) in highScores {
            highScoresDict[mode.rawValue] = score
        }
        
        if let encoded = try? JSONEncoder().encode(highScoresDict) {
            UserDefaults.standard.set(encoded, forKey: "highScores")
        }
    }
    
    private func loadHighScores() {
        if let data = UserDefaults.standard.data(forKey: "highScores") {
            if let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
                highScores.removeAll()
                for (modeString, score) in decoded {
                    if let mode = GameMode(rawValue: modeString) {
                        highScores[mode] = score
                    }
                }
            }
        }
    }
} 