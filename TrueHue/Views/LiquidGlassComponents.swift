//
//  LiquidGlassComponents.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import SwiftUI

// MARK: - Liquid Glass Background

struct LiquidGlassBackground: View {
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.8),
                    Color(.systemBackground).opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Floating glass elements
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: CGFloat.random(in: 60...120))
                    .blur(radius: 20)
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -400...400)
                    )
                    .opacity(0.3)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Liquid Glass Button

struct LiquidGlassButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon with glass effect
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 48, height: 48)
                        .blur(radius: 0.5)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
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
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Liquid Glass Score Card

struct LiquidGlassScoreCard: View {
    let mode: String
    let score: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(mode)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
            
            Text("\(score)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .blur(radius: 0.3)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.quaternary, lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Liquid Glass Action Button

struct LiquidGlassActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .blur(radius: 0.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(color.opacity(0.8))
                            .blur(radius: 0.3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.quaternary, lineWidth: 0.5)
                    )
            )
            .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Liquid Glass Color Button

struct LiquidGlassColorButton: View {
    let color: Color
    let isCorrect: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(height: 90)
                    .shadow(color: color.opacity(0.3), radius: 15, x: 0, y: 8)
                
                // Glass overlay
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .frame(height: 90)
                    .opacity(0.1)
                
                // Border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.quaternary, lineWidth: 1)
                    .frame(height: 90)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
} 