//
//  Challenge.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation
import CoreText
import UIKit

class Challenge: Codable {
    var id: String = ""
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


enum ChallengeCategory: Int, CaseIterable, Codable {
    case health
    case discipline
    case work
    case home
    
    func string() -> String {
        switch self {
        case .health:
            return "Здоровье"
        case .discipline:
            return "Дисциплина"
        case .work:
            return "Работа"
        case .home:
            return "Дом"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .health:
            return UIImage(named: "HealthIcon")
        case .discipline:
            return UIImage(named: "DisciplineIcon")
        case .work:
            return UIImage(named: "WorkIcon")
        case .home:
            return UIImage(named: "HomeIcon")
        }
    }
}

enum ChallengeDifficulty: Int, CaseIterable, Codable {
    case lowest
    case low
    case average
    case high
    case highest
    
    func string() -> String {
        switch self {
        case .lowest:
            return "Самый легкий"
        case .low:
            return "Легкий"
        case .average:
            return "Средний"
        case .high:
            return "Трудный"
        case .highest:
            return "Самый трудный"
        }
    }
    
    func reward() -> Int {
        switch self {
        case .lowest:
            return 5
        case .low:
            return 10
        case .average:
            return 50
        case .high:
            return 200
        case .highest:
            return 500
        }
    }
}

enum ChallengeType: Int, CaseIterable, Codable {
    case singleAction
    case counter
    case checkbox
    
    func string() -> String {
        switch self {
        case .singleAction:
            return "Одно действие"
        case .counter:
            return "Счетчик"
        case .checkbox:
            return "Список дел"
        }
    }
}
 
enum ChallengeFee: Int, CaseIterable, Codable {
    case none
    case normal
    case critical
    
    func string() -> String {
        switch self {
        case .none:
            return "Нет"
        case .normal:
            return "Обычный"
        case .critical:
            return "Критический"
        }
    }
    
    func fee() -> Int {
        switch self {
        case .none:
            return 0
        case .normal:
            return 50
        case .critical:
            return 500
        }
    }
}

enum ChallengeDuration: Int, CaseIterable, Codable {
    case daily
    case weekly
    case monthly
    
    func string() -> String {
        switch self {
        case .daily:
            return "Ежедневное"
        case .weekly:
            return "На неделю"
        case .monthly:
            return "На месяц"
        }
    }
}
