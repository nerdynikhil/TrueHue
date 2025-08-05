//
//  ChronoModeView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct ChronoModeView: View {
    @EnvironmentObject var gameManager: GameManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Liquid Glass Background
            LiquidGlassBackground()
            
            VStack(spacing: 40) {
                // Header with Timer and Score
                HStack {
                    Button(action: {
                        gameManager.resetGame()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                                .blur(radius: 0.5)
                            
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Timer Display with Liquid Glass
                    VStack(spacing: 4) {
                        Text("Time")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                        
                        Text("\(gameManager.timeRemaining)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(timerColor)
                    }
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
                    
                    Spacer()
                    
                    // Score Display with Liquid Glass
                    VStack(spacing: 4) {
                        Text("Score")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                        
                        Text("\(gameManager.currentScore)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                    }
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
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                // Color Name Display with Liquid Glass
                VStack(spacing: 24) {
                    Text(gameManager.currentColorName)
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundStyle(gameManager.currentDisplayColor)
                        .multilineTextAlignment(.center)
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
                    
                    // Color Preview with Liquid Glass
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(gameManager.currentDisplayColor)
                            .frame(width: 140, height: 140)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.quaternary, lineWidth: 1)
                            )
                            .shadow(color: gameManager.currentDisplayColor.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        // Glass overlay
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .frame(width: 140, height: 140)
                            .opacity(0.1)
                    }
                }
                
                Spacer()
                
                // Action Buttons with Liquid Glass
                VStack(spacing: 20) {
                    LiquidGlassActionButton(
                        title: "Match ✅",
                        icon: "checkmark.circle.fill",
                        color: .green
                    ) {
                        gameManager.checkAnswer(userThinksMatch: true)
                    }
                    
                    LiquidGlassActionButton(
                        title: "No Match ❌",
                        icon: "xmark.circle.fill",
                        color: .red
                    ) {
                        gameManager.checkAnswer(userThinksMatch: false)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
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
        .navigationBarHidden(true)
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