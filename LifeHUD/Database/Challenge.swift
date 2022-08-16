//
//  Challenge.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation
import CoreText

class Challenge: Codable {
    var id: Int = 0
    var title: String = ""
    var duration: ChallengeDuration = .daily
    var category: ChallengeCategory = .health
    var difficulty: ChallengeDifficulty = .lowest
    var type: ChallengeType = .singleAction
    var failFee: ChallengeFee = .none
    var description: String = ""
    var count: Int = 0
    var toDos: [String] = [""]
    var progress: [Int]? 
}


enum ChallengeCategory: Int, Codable {
    case health
    case discipline
    case work
}

enum ChallengeDifficulty: Int, Codable {
    case lowest
    case low
    case average
    case high
    case highest
}

enum ChallengeType: Int, Codable {
    case singleAction
    case counter
    case checkbox
}
 
enum ChallengeFee: Int, Codable {
    case none
    case normal
    case critical
}

enum ChallengeDuration: Int, Codable {
    case daily
    case weekly
    case monthly
}
