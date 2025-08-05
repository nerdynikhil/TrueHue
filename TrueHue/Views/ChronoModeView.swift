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
        VStack(spacing: 40) {
            // Header with Timer and Score
            HStack {
                Button(action: {
                    gameManager.resetGame()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Timer Display
                VStack(spacing: 4) {
                    Text("Time")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Text("\(gameManager.timeRemaining)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(timerColor)
                }
                
                Spacer()
                
                // Score Display
                VStack(spacing: 4) {
                    Text("Score")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Text("\(gameManager.currentScore)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
            
            // Color Name Display
            VStack(spacing: 20) {
                Text(gameManager.currentColorName)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(gameManager.currentDisplayColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Color Preview
                RoundedRectangle(cornerRadius: 16)
                    .fill(gameManager.currentDisplayColor)
                    .frame(width: 120, height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray4), lineWidth: 2)
                    )
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 16) {
                Button(action: {
                    gameManager.checkAnswer(userThinksMatch: true)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("Match ✅")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Button(action: {
                    gameManager.checkAnswer(userThinksMatch: false)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("No Match ❌")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(
            NavigationLink(
                destination: GameOverView(),
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