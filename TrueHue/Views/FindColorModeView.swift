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
        ZStack {
            // Liquid Glass Background
            LiquidGlassBackground()
            
            VStack(spacing: 40) {
                // Header with Score
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
                    
                    Spacer()
                    
                    // Placeholder for balance
                    Color.clear
                        .frame(width: 44, height: 44)
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
                }
                
                Spacer()
                
                // Color Grid with Liquid Glass
                VStack(spacing: 16) {
                    ForEach(0..<2, id: \.self) { row in
                        HStack(spacing: 16) {
                            ForEach(0..<3, id: \.self) { column in
                                let index = row * 3 + column
                                LiquidGlassColorButton(
                                    color: colorOptions.indices.contains(index) ? colorOptions[index] : .gray,
                                    isCorrect: index == correctColorIndex
                                ) {
                                    handleColorSelection(index: index)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
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

#Preview {
    FindColorModeView()
        .environmentObject(GameManager())
} 