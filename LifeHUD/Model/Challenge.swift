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

enum ChallengeParameter {
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
    
    init?(paramterName: String, value: Any) {
        switch paramterName {
        case "id":
            guard let value = value as? String else {
                return nil
            }
            self = .id(value: value)
        case "title":
            guard let value = value as? String else {
                return nil
            }
            self = .title(value: value)
        case "duration":
            guard let stringValue = value as? String,
                  let value = ChallengeDuration(stringValue: stringValue) else {
                return nil
            }
            self = .duration(value: value)
        case "category":
            guard let stringValue = value as? String,
                  let value = ChallengeCategory(stringValue: stringValue) else {
                return nil
            }
            self = .category(value: value)
        case "difficulty":
            guard let stringValue = value as? String,
                  let value = ChallengeDifficulty(stringValue: stringValue) else {
                return nil
            }
            self = .difficulty(value: value)
        case "type":
            guard let stringValue = value as? String,
                  let value = ChallengeType(stringValue: stringValue) else {
                return nil
            }
            self = .type(value: value)
        case "failFee":
            guard let stringValue = value as? String,
                  let value = ChallengeFee(stringValue: stringValue) else {
                return nil
            }
            self = .failFee(value: value)
        case "description":
            guard let value = value as? String else {
                return nil
            }
            self = .description(value: value)
        case "count":
            guard let value = value as? Int else {
                return nil
            }
            self = .count(value: value)
        case "toDos":
            guard let value = value as? [String] else {
                return nil
            }
            self = .toDos(value: value)
        case "progress":
            guard let value = value as? [Int] else {
                return nil
            }
            self = .progress(value: value)
        case "startDate":
            guard let value = value as? Date else {
                return nil
            }
            self = .startDate(value: value)
        case "endDate":
            guard let value = value as? Date else {
                return nil
            }
            self = .endDate(value: value)
        case "dueDate":
            guard let value = value as? Date else {
                return nil
            }
            self = .dueDate(value: value)
        default:
            return nil
        }
    }
}

enum ChallengeCategory: Int, CaseIterable, Codable {
    case health
    case discipline
    case work
    case home
    
    init?(stringValue: String) {
        switch stringValue {
        case "Здоровье":
            self = .health
        case "Дисциплина":
            self = .discipline
        case "Работа":
            self = .work
        case "Дом":
            self = .home
        default:
            return nil
        }
    }
    
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
    
    func xpStorageKey() -> String {
        switch self {
        case .health:
            return "healthXP"
        case .discipline:
            return "disciplineXP"
        case .work:
            return "workXP"
        case .home:
            return "homeXP"
        }
    }
}

enum ChallengeDifficulty: Int, CaseIterable, Codable {
    case lowest
    case low
    case average
    case high
    case highest
    
    init?(stringValue: String) {
        switch stringValue {
        case "Самый легкий":
            self = .lowest
        case "Легкий":
            self = .low
        case "Средний":
            self = .average
        case "Трудный":
            self = .high
        case "Самый трудный":
            self = .highest
        default:
            return nil
        }
    }
    
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
    
    init?(stringValue: String) {
        switch stringValue {
        case "Одно действие":
            self = .singleAction
        case "Счетчик":
            self = .counter
        case "Список дел":
            self = .checkbox
        default:
            return nil
        }
    }
    
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
    
    init?(stringValue: String) {
        switch stringValue {
        case "Нет":
            self = .none
        case "Обычный":
            self = .normal
        case "Критический":
            self = .critical
        default:
            return nil
        }
    }
    
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
    
    init?(stringValue: String) {
        switch stringValue {
        case "Ежедневное":
            self = .daily
        case "На неделю":
            self = .weekly
        case "На месяц":
            self = .monthly
        default:
            return nil
        }
    }
    
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

extension Challenge {
    mutating func applyParameter(_ parameter: ChallengeParameter) {
        switch parameter {
        case .id(value: let value):
            self.id = value
        case .title(value: let value):
            self.title = value
        case .duration(value: let value):
            self.duration = value
        case .category(value: let value):
            self.category = value
        case .difficulty(value: let value):
            self.difficulty = value
        case .type(value: let value):
            self.type = value
        case .failFee(value: let value):
            self.failFee = value
        case .description(value: let value):
            self.description = value
        case .count(value: let value):
            self.count = value
        case .toDos(value: let value):
            self.toDos = value
        case .progress(value: let value):
            self.progress = value
        case .startDate(value: let value):
            self.startDate = value
        case .endDate(value: let value):
            self.endDate = value
        case .dueDate(value: let value):
            self.dueDate = value
        }
    }
}
