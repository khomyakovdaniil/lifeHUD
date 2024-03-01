//
//  ChallengesFullInfoViewViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 01.03.2024.
//

import Foundation
import UIKit

struct ChallengesFullInfoViewViewModel {
    
    private var challenge: Challenge
    
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    var id: String {
        return challenge.id
    }
    
    var title: String {
        return challenge.title
    }
    
    var duration: String {
        return challenge.duration.string()
    }
    
    var categoryImage: UIImage? {
        switch challenge.category {
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
    
    var reward: String {
        var reward = 0
        switch challenge.difficulty {
            case .lowest:
                reward = 5
            case .low:
                reward = 10
            case .average:
                reward = 50
            case .high:
                reward = 200
            case .highest:
                reward = 500
        }
        return "+ \(reward) XP"
    }
    
    var type: String {
        return challenge.type.string()
    }
    
    var failFee: String? {
        var fee = 0
        switch challenge.failFee {
        case .none:
            return nil
        case .normal:
            fee = 50
        case .critical:
            fee = 500
        }
        return "- \(fee) XP"
    }
    
    var description: String {
        return challenge.description
    }
    
    var count: Int {
        return challenge.count
    }
    
    var toDos: [String]? {
        return challenge.toDos
    }
    
    var progress: (aim: String?, crrnt: Float?) {
        var current = Float(0)
        let progress = challenge.progress ?? []
        current = Float(progress.count)
        switch challenge.type {
        case .singleAction:
            return (nil, nil)
        case .counter:
            return (String(challenge.count),
                    Float(progress.count)/Float(challenge.count))
        case .checkbox:
            guard let maxCount = challenge.toDos?.count else {
                return (nil, nil)
            }
            return (String(maxCount),
                    Float(progress.count)/Float(maxCount))
        }
    }
    
}
