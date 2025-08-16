//
//  FindColorModeView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct FindColorModeView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var colorOptions: [Color] = []
    @State private var correctColorIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Score
            HStack {
                Spacer()
                
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
                
                Spacer()
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
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Color Grid
                VStack(spacing: 16) {
                    ForEach(0..<2, id: \.self) { row in
                        HStack(spacing: 16) {
                            ForEach(0..<3, id: \.self) { column in
                                let index = row * 3 + column
                                ColorButton(
                                    color: colorOptions.indices.contains(index) ? colorOptions[index] : .gray,
                                    isCorrect: index == correctColorIndex
                                ) {
                                    handleColorSelection(index: index)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .background(
            NavigationLink(
                destination: GameOverView()
                    .environmentObject(gameManager)
                    .environmentObject(GameCenterManager.shared),
                isActive: Binding(
                    get: { gameManager.gameState == .gameOver },
                    set: { _ in }
                )
            ) {
                EmptyView()
            }
        )
        .navigationTitle("Find Color")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            gameManager.generateFindColorQuestion()
            generateColorOptions()
        }
        .onDisappear {
            // Reset game when leaving the view
            if gameManager.gameState != .gameOver {
                HapticManager.shared.softHaptic()
                gameManager.resetGame()
            }
        }
    }
    
    private func generateColorOptions() {
        let allColors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .brown, .gray, .black, .white, .cyan, .indigo, .teal]
        
        // Get the correct color from the game manager
        let correctColor = gameManager.currentDisplayColor
        
        // Generate 5 random distractors
        var distractors: [Color] = []
        let availableColors = allColors.filter { $0 != correctColor }
        
        while distractors.count < 5 {
            let randomColor = availableColors.randomElement()!
            if !distractors.contains(randomColor) {
                distractors.append(randomColor)
            }
        }
        
        // Combine correct color with distractors and shuffle
        colorOptions = [correctColor] + distractors
        colorOptions.shuffle()
        
        // Find the index of the correct color
        correctColorIndex = colorOptions.firstIndex(of: correctColor) ?? 0
    }
    
    private func handleColorSelection(index: Int) {
        let isCorrect = index == correctColorIndex
        
        if isCorrect {
            HapticManager.shared.lightHaptic()
            gameManager.currentScore += 1
            // Generate new question
            gameManager.generateFindColorQuestion()
            generateColorOptions()
        } else {
            HapticManager.shared.lightHaptic()
            // Game over for Find Color mode
            gameManager.endGame()
        }
    }
}

struct ColorButton: View {
    let color: Color
    let isCorrect: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.lightHaptic()
            action()
        }) {
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.quaternary, lineWidth: 1)
                )
                .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FindColorModeView()
        .environmentObject(GameManager())
        .environmentObject(GameCenterManager.shared)
} 