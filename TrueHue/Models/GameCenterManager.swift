//
//  GameCenterManager.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import Foundation
import GameKit
import SwiftUI
import Combine

class GameCenterManager: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var isAuthenticated = false
    @Published var currentPlayer: GKPlayer?
    @Published var localLeaderboards: [GameMode: [LeaderboardEntry]] = [:]
    @Published var achievements: [Achievement] = []
    
    // MARK: - Singleton
    static let shared = GameCenterManager()
    
    // MARK: - Private Properties
    private var authenticationViewController: UIViewController?
    
    override init() {
        super.init()
        setupGameCenter()
    }
    
    // MARK: - Game Center Setup
    private func setupGameCenter() {
        // Set up authentication handler
        GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
            DispatchQueue.main.async {
                if let viewController = viewController {
                    // Present authentication view controller
                    self?.authenticationViewController = viewController
                    self?.presentAuthenticationViewController()
                } else if error != nil {
                    // Handle authentication error
                    print("Game Center authentication error: \(error?.localizedDescription ?? "Unknown error")")
                    self?.isAuthenticated = false
                } else {
                    // Player is authenticated
                    self?.isAuthenticated = GKLocalPlayer.local.isAuthenticated
                    if self?.isAuthenticated == true {
                        self?.currentPlayer = GKLocalPlayer.local
                        self?.loadLocalLeaderboards()
                        self?.loadAchievements()
                    }
                }
            }
        }
    }
    
    private func presentAuthenticationViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let rootViewController = window.rootViewController
        rootViewController?.present(authenticationViewController!, animated: true)
    }
    
    // MARK: - Leaderboard Management
    func submitScore(_ score: Int, for mode: GameMode) {
        // Store locally first
        submitLocalScore(score, for: mode)
        
        // If authenticated, prepare for future global submission
        if isAuthenticated {
            // Store score for later submission when global leaderboards are available
            storeScoreForGlobalSubmission(score, for: mode)
        }
    }
    
    private func submitLocalScore(_ score: Int, for mode: GameMode) {
        let entry = LeaderboardEntry(
            playerName: currentPlayer?.displayName ?? "Player",
            score: score,
            date: Date(),
            rank: calculateLocalRank(score, for: mode)
        )
        
        if localLeaderboards[mode] == nil {
            localLeaderboards[mode] = []
        }
        
        localLeaderboards[mode]?.append(entry)
        localLeaderboards[mode]?.sort { $0.score > $1.score }
        
        // Update ranks after sorting
        updateLocalRanks(for: mode)
        
        // Save to UserDefaults
        saveLocalLeaderboards()
        
        // Check for achievements
        checkAchievements(for: mode, score: score)
    }
    
    private func calculateLocalRank(_ score: Int, for mode: GameMode) -> Int {
        guard let entries = localLeaderboards[mode] else { return 1 }
        return entries.filter { $0.score > score }.count + 1
    }
    
    private func updateLocalRanks(for mode: GameMode) {
        guard let entries = localLeaderboards[mode] else { return }
        for (index, entry) in entries.enumerated() {
            localLeaderboards[mode]?[index].rank = index + 1
        }
    }
    
    private func storeScoreForGlobalSubmission(_ score: Int, for mode: GameMode) {
        // This will be used when global leaderboards are available
        // For now, just store locally
    }
    
    // MARK: - Achievement System
    private func checkAchievements(for mode: GameMode, score: Int) {
        // Check for score-based achievements
        if score >= 10 && !hasAchievement(.score10) {
            unlockAchievement(.score10)
        }
        if score >= 25 && !hasAchievement(.score25) {
            unlockAchievement(.score25)
        }
        if score >= 50 && !hasAchievement(.score50) {
            unlockAchievement(.score50)
        }
        
        // Check for mode-specific achievements
        switch mode {
        case .classic:
            if score >= 5 && !hasAchievement(.classicMaster) {
                unlockAchievement(.classicMaster)
            }
        case .chrono:
            if score >= 15 && !hasAchievement(.chronoMaster) {
                unlockAchievement(.chronoMaster)
            }
        case .findColor:
            if score >= 20 && !hasAchievement(.findColorMaster) {
                unlockAchievement(.findColorMaster)
            }
        }
    }
    
    private func hasAchievement(_ type: AchievementType) -> Bool {
        return achievements.contains { $0.type == type && $0.isUnlocked }
    }
    
    private func unlockAchievement(_ type: AchievementType) {
        if let index = achievements.firstIndex(where: { $0.type == type }) {
            achievements[index].isUnlocked = true
            achievements[index].unlockedDate = Date()
            saveAchievements()
            
            // Trigger haptic feedback
            HapticManager.shared.lightHaptic()
        }
    }
    
    // MARK: - Data Persistence
    private func saveLocalLeaderboards() {
        // Convert to storable format
        var storableData: [String: Data] = [:]
        
        for (mode, entries) in localLeaderboards {
            if let encoded = try? JSONEncoder().encode(entries) {
                storableData[mode.rawValue] = encoded
            }
        }
        
        // Save to UserDefaults
        if let encoded = try? JSONEncoder().encode(storableData) {
            UserDefaults.standard.set(encoded, forKey: "localLeaderboards")
        }
    }
    
    private func loadLocalLeaderboards() {
        guard let data = UserDefaults.standard.data(forKey: "localLeaderboards"),
              let storableData = try? JSONDecoder().decode([String: Data].self, from: data) else {
            return
        }
        
        for (modeString, entryData) in storableData {
            if let mode = GameMode(rawValue: modeString),
               let entries = try? JSONDecoder().decode([LeaderboardEntry].self, from: entryData) {
                localLeaderboards[mode] = entries
            }
        }
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: "achievements")
        }
    }
    
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: "achievements"),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        } else {
            // Initialize default achievements
            initializeDefaultAchievements()
        }
    }
    
    private func initializeDefaultAchievements() {
        achievements = AchievementType.allCases.map { type in
            Achievement(type: type, isUnlocked: false, unlockedDate: nil)
        }
        saveAchievements()
    }
    
    // MARK: - Public Methods
    func getTopScores(for mode: GameMode, limit: Int = 10) -> [LeaderboardEntry] {
        guard let entries = localLeaderboards[mode] else { return [] }
        return Array(entries.prefix(limit))
    }
    
    func getPlayerRank(for mode: GameMode) -> Int? {
        guard let entries = localLeaderboards[mode] else { return nil }
        // For now, return the best rank the player has achieved
        return entries.first?.rank
    }
    
    func getPlayerBestScore(for mode: GameMode) -> Int? {
        guard let entries = localLeaderboards[mode] else { return nil }
        return entries.first?.score
    }
}

// MARK: - Supporting Types
struct LeaderboardEntry: Codable, Identifiable {
    let id = UUID()
    let playerName: String
    let score: Int
    let date: Date
    var rank: Int
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

enum AchievementType: String, CaseIterable, Codable {
    case score10 = "score10"
    case score25 = "score25"
    case score50 = "score50"
    case classicMaster = "classicMaster"
    case chronoMaster = "chronoMaster"
    case findColorMaster = "findColorMaster"
    
    var title: String {
        switch self {
        case .score10: return "Getting Started"
        case .score25: return "Color Enthusiast"
        case .score50: return "Color Master"
        case .classicMaster: return "Classic Master"
        case .chronoMaster: return "Speed Demon"
        case .findColorMaster: return "Find Color Expert"
        }
    }
    
    var description: String {
        switch self {
        case .score10: return "Score 10 points in any mode"
        case .score25: return "Score 25 points in any mode"
        case .score50: return "Score 50 points in any mode"
        case .classicMaster: return "Score 5 points in Classic mode"
        case .chronoMaster: return "Score 15 points in Chrono mode"
        case .findColorMaster: return "Score 20 points in Find Color mode"
        }
    }
    
    var iconName: String {
        switch self {
        case .score10: return "star.fill"
        case .score25: return "star.circle.fill"
        case .score50: return "crown.fill"
        case .classicMaster: return "gamecontroller.fill"
        case .chronoMaster: return "timer"
        case .findColorMaster: return "eye.fill"
        }
    }
}

struct Achievement: Codable, Identifiable {
    let id = UUID()
    let type: AchievementType
    var isUnlocked: Bool
    var unlockedDate: Date?
    
    var formattedUnlockDate: String? {
        guard let date = unlockedDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
