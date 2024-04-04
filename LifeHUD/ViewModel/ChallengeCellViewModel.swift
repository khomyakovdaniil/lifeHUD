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

struct ChallengeCellViewModel: ChallengeCellDisplayProtocol {
    
    private var challenge: Challenge
    
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    // Challenge title
    var title: String {
        return challenge.title
    }
    
    // Category is shown with corresponging image
    var categoryImage: UIImage {
        return challenge.category.image()
    }
    
    // Text showing how much XP you get for completing the challenge successfully
    var reward: String {
        let reward = challenge.difficulty.reward()
        return "+ \(reward) XP" // TODO: собирать итоговые стринги - ответственность вью
    }
    
    // Text showing how much XP you loose for failing the challenge
    var failFee: String? {
        let fee = challenge.failFee.fee()
        return "- \(fee) XP"
    }
    
    // Progress according to challenge type (single action, repetitions, sub tasks). Only for showing the progress bar
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
