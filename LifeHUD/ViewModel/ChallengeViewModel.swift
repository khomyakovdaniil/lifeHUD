//
//  ChallengeViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 01.03.2024.
//

import Foundation
import UIKit

protocol ChallengeCellDisplayProtocol { // All the info required to display challenge cell
    var title: String { get }
    var categoryImage: UIImage { get }
    var reward: String { get }
    var failFee: String? { get }
    var progress: (String?, Float?) { get }
}

struct ChallengeViewModel: ChallengeCellDisplayProtocol {
    
    private var challenge: Challenge
    
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    var title: String {
        return challenge.title
    }
    
    var categoryImage: UIImage {
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
    
    var progress: (String?, Float?) {
        var current = Float(0)
        let progress = challenge.progress ?? []
        current = Float(progress.count)
        switch challenge.type {
        case .singleAction:
            return (nil, nil)
        case .counter:
            return (String(challenge.count),
                    current/Float(challenge.count))
        case .checkbox:
            guard let maxCount = challenge.toDos?.count else {
                return (nil, nil)
            }
            return (String(maxCount),
                    current/Float(maxCount))
        }
    }
}
