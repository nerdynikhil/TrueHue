//
//  LeaderboardView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI
import Foundation
import GameKit

struct LeaderboardView: View {
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @State private var selectedMode: GameMode = .classic
    @State private var showingAchievements = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    // Game Mode Selector
                    Picker("Game Mode", selection: $selectedMode) {
                        ForEach(GameMode.allCases, id: \.self) { mode in
                            Text(mode.displayName)
                                .tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                    
                    // Current Player Info
                    if gameCenterManager.isAuthenticated {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(gameCenterManager.currentPlayer?.displayName ?? "Player")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                if let bestScore = gameCenterManager.getPlayerBestScore(for: selectedMode) {
                                    Text("Best: \(bestScore)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingAchievements = true
                            }) {
                                Image(systemName: "trophy.fill")
                                    .font(.title2)
                                    .foregroundStyle(.yellow)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 16)
                
                // Leaderboard Content
                ScrollView {
                    LazyVStack(spacing: 12) {
                        let topScores = gameCenterManager.getTopScores(for: selectedMode, limit: 20)
                        
                        if topScores.isEmpty {
                            // Empty State
                            VStack(spacing: 16) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(Color(.quaternaryLabel))
                                
                                Text("No scores yet!")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text("Play \(selectedMode.displayName) mode to set the first record")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 60)
                        } else {
                            // Leaderboard Entries
                            ForEach(Array(topScores.enumerated()), id: \.element.id) { index, entry in
                                LeaderboardRow(
                                    entry: entry,
                                    rank: index + 1,
                                    isCurrentPlayer: entry.playerName == gameCenterManager.currentPlayer?.displayName
                                )
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Leaderboards")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAchievements) {
                AchievementsView()
                    .environmentObject(gameCenterManager)
            }
        }
    }
}

#if DEBUG
struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
            .environmentObject(GameCenterManager.shared)
    }
}
#endif

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let rank: Int
    let isCurrentPlayer: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank Badge
            ZStack {
                Circle()
                    .fill(rankColor)
                    .frame(width: 40, height: 40)
                
                Text("\(rank)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            // Player Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.playerName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(isCurrentPlayer ? .blue : .primary)
                    
                    if isCurrentPlayer {
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                
                Text(entry.formattedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Score
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.score)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("points")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.quaternarySystemFill).opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isCurrentPlayer ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 2)
                )
        )
        .scaleEffect(isCurrentPlayer ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCurrentPlayer)
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .blue
        }
    }
}

struct AchievementsView: View {
    @EnvironmentObject var gameCenterManager: GameCenterManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(gameCenterManager.achievements) { achievement in
                        AchievementRow(achievement: achievement)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            // Achievement Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color.yellow : Color(.quaternarySystemFill))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.type.iconName)
                    .font(.title2)
                    .foregroundStyle(achievement.isUnlocked ? .white : .secondary)
            }
            
            // Achievement Info
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.type.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(achievement.isUnlocked ? .primary : .secondary)
                
                Text(achievement.type.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if achievement.isUnlocked, let unlockDate = achievement.formattedUnlockDate {
                    Text("Unlocked: \(unlockDate)")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
            
            Spacer()
            
            // Status Indicator
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundStyle(Color(.quaternaryLabel))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(achievement.isUnlocked ? Color.green.opacity(0.1) : Color(.quaternarySystemFill).opacity(0.3))
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}
