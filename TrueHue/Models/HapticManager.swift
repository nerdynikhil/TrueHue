//
//  HapticManager.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import Foundation
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let softImpact = UIImpactFeedbackGenerator(style: .soft)
    
    private init() {
        // Prepare the haptic engines for immediate use
        lightImpact.prepare()
        softImpact.prepare()
    }
    
    // MARK: - Haptic Feedback Methods
    
    /// Light haptic for mode selection and general interactions
    func lightHaptic() {
        lightImpact.impactOccurred()
    }
    
    /// Soft haptic for navigation and confirmation
    func softHaptic() {
        softImpact.impactOccurred()
    }
    
    /// Prepare haptics for better performance
    func prepareHaptics() {
        lightImpact.prepare()
        softImpact.prepare()
    }
}
