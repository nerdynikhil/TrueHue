//
//  GameMode.swift
//  TrueHue
//
//  Created by Nikhil Barik on 05/08/25.
//

import Foundation

enum GameMode: String, Codable, CaseIterable {
    case classic
    case chrono
    case findColor
    
    var displayName: String {
        switch self {
        case .classic: return "Classic"
        case .chrono: return "Chrono"
        case .findColor: return "Find Color"
        }
    }
}