//
//  ChallengesListViewViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 01.03.2024.
//

import Foundation
import UIKit

struct ChallengesListViewViewModel {
    
    private var challenge: Challenge
    
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    var title: String {
        return challenge.title
    }
    
    var categoryImage: UIImage? {
        return challenge.category.image()
    }
    
    var reward: String {
        let reward = challenge.difficulty.reward()
        return "+ \(reward) XP"
    }
    
    var failFee: String? {
        let fee = challenge.failFee.fee()
        return "- \(fee) XP"
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
