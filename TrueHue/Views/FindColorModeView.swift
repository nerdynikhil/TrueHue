//
//  FindColorModeView.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

struct FindColorModeView: View {
    @EnvironmentObject var gameManager: GameManager
    @Environment(\.presentationMode) var presentationMode
    @State private var colorOptions: [Color] = []
    @State private var correctColorIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 40) {
            // Header with Score
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
                
                VStack(spacing: 4) {
                    Text("Score")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Text("\(gameManager.currentScore)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Placeholder for balance
                Color.clear
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
            
            // Color Name Display
            VStack(spacing: 20) {
                Text(gameManager.currentColorName)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.primary) // Always neutral color for Find Color mode
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
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
            
            Spacer()
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
        .onAppear {
            gameManager.generateFindColorQuestion()
            generateColorOptions()
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
            gameManager.currentScore += 1
            // Generate new question
            gameManager.generateFindColorQuestion()
            generateColorOptions()
        } else {
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
        Button(action: action) {
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray4), lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FindColorModeView()
        .environmentObject(GameManager())
} 