//
//  Challenge.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation
import CoreText
import UIKit

struct Challenge: Codable {
    var id: String = ""
    var title: String = ""
    var duration: ChallengeDuration = .daily
    var category: ChallengeCategory = .health
    var difficulty: ChallengeDifficulty = .lowest
    var type: ChallengeType = .singleAction
    var failFee: ChallengeFee = .none
    var description: String = ""
    var count: Int = 0
    var toDos: [String]? = []
    var progress: [Int]? = []
    var startDate = Date()
    var endDate = Date()
    var dueDate = Date()
}

enum ChallengeParameters {
    case id(value: String = "")
    case title(value: String = "")
    case duration(value: ChallengeDuration = .daily)
    case category(value: ChallengeCategory = .health)
    case difficulty(value: ChallengeDifficulty = .lowest)
    case type(value: ChallengeType = .singleAction)
    case failFee(value: ChallengeFee = .none)
    case description(value: String = "")
    case count(value: Int = 0)
    case toDos(value: [String]? = [])
    case progress(value: [Int]? = [])
    case startDate(value: Date = Date())
    case endDate(value: Date = Date())
    case dueDate(value: Date = Date())
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
    
    func image() -> UIImage {
        switch self {
        case .health:
            return UIImage(named: "HealthIcon") ?? UIImage()
        case .discipline:
            return UIImage(named: "DisciplineIcon") ?? UIImage()
        case .work:
            return UIImage(named: "WorkIcon") ?? UIImage()
        case .home:
            return UIImage(named: "HomeIcon") ?? UIImage()
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
