//
//  EmojiViewModel.swift
//  Moves
//
//  Created by Adam Sherif on 1/15/25.
//

import Foundation

enum EmojiViewModel: Int, CaseIterable {
    case lunch
    case breakfast
    case brunch
    case houseParty
    case gathering
    case gym
    case sport
    case wacthParty
    case clubEvent
    case drinks
    case smoking
    
    
    var title: String {
        
        switch self {
        case.lunch: return "🍴"
        case.breakfast: return "🍳"
        case.brunch: return "🥯"
        case.houseParty: return "🎉"
        case.gathering: return "🎟️"
        case.gym: return "💪"
        case.sport: return "⚽"
        case.wacthParty: return "🍿"
        case.clubEvent: return "♣️"
        case.drinks: return "🍸"
        case.smoking: return "🚬"
        }
    }
}
