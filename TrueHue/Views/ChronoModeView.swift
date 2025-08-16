//
//  ChronoModeView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct ChronoModeView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Timer and Score
            HStack {
                // Timer Display - Left Half
                VStack(spacing: 2) {
                    Text("Time")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Text("\(gameManager.timeRemaining)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(timerColor)
                }
                .frame(maxWidth: .infinity)
                
                // Score Display - Right Half
                VStack(spacing: 2) {
                    Text("Score")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Text("\(gameManager.currentScore)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
            
            Spacer()
            
            // Game Content
            VStack(spacing: 32) {
                // Color Name Display
                VStack(spacing: 16) {
                    Text(gameManager.currentColorName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(gameManager.currentDisplayColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Color Preview
                    RoundedRectangle(cornerRadius: 20)
                        .fill(gameManager.currentDisplayColor)
                        .frame(width: 160, height: 160)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.quaternary, lineWidth: 1)
                        )
                        .shadow(color: gameManager.currentDisplayColor.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 20) {
                Button(action: {
                    HapticManager.shared.lightHaptic()
                    gameManager.checkAnswer(userThinksMatch: true)
                }) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 120, height: 120)
                        .background(.green, in: RoundedRectangle(cornerRadius: 30))
                        .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    HapticManager.shared.lightHaptic()
                    gameManager.checkAnswer(userThinksMatch: false)
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 120, height: 120)
                        .background(.red, in: RoundedRectangle(cornerRadius: 30))
                        .shadow(color: .red.opacity(0.3), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(
            NavigationLink(
                destination: GameOverView()
                    .environmentObject(gameManager),
                isActive: Binding(
                    get: { gameManager.gameState == .gameOver },
                    set: { _ in }
                )
            ) {
                EmptyView()
            }
        )
        .navigationTitle("Chrono Mode")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            // Reset game when leaving the view
            if gameManager.gameState != .gameOver {
                HapticManager.shared.softHaptic()
                gameManager.resetGame()
            }
        }
    }
    
    private var timerColor: Color {
        if gameManager.timeRemaining > 20 {
            return .green
        } else if gameManager.timeRemaining > 10 {
            return .orange
        } else {
            return .red
        }
    }
}

#Preview {
    ChronoModeView()
        .environmentObject(GameManager())
} 