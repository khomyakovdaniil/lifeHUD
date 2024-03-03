//
//  UserHistory.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 09.09.2022.
//

import Foundation

struct HistoryEntry: Codable {
    let date: Date
    let stats: DayStats
}

struct DayStats: Codable, Equatable {
    let challengeID: String
    let success: Bool
}
