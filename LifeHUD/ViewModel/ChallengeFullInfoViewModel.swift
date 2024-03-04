//
//  ChallengeFullInfoViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 01.03.2024.
//

import Foundation
import UIKit

protocol ChallengeFullInfoDisplayProtocol { // All the info required to display challenge full info
    var title: String { get }
    var categoryImage: UIImage { get }
    var reward: String { get }
    var failFee: String? { get }
    var progress: [Int]? { get }
}

protocol ProgressTrackingProtocol { // Behavior required to track progress
    var challengeManager: ChallengesRepository { get }
    var challengeId: String { get }
    func trackProgressForChallenge(id: String, toDos: [Int]) // For challenges with sub tasks
    func trackProgressForChallenge(id: String, repetitions: Float) // For multi repetitions challenges
}

protocol ChallengeCreationProtocol { // Behavior required to create challenge
    var challengeManager: ChallengesRepository { get }
    func createChallenge(with parameters: [Challenge.Parameters]) -> Challenge
}

struct ChallengeFullInfoViewModel: ChallengeFullInfoDisplayProtocol, ProgressTrackingProtocol {
    
    var challengeManager: ChallengesRepository
    
    private var challenge: Challenge
    
    init(challenge: Challenge) {
        self.challenge = challenge
        self.challengeManager = ChallengesRepository.shared
    }
    
    var challengeId: String {
        return challenge.id
    }
    
    var title: String {
        return challenge.title
    }
    
    var duration: String {
        return challenge.duration.string()
    }
    
    var category: String {
        return challenge.category.string()
    }
    
    var categoryImage: UIImage {
        return challenge.category.image()
    }
    
    var difficulty: String {
        return challenge.difficulty.string()
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
    
    var type: ChallengeType {
        return challenge.type
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
    
    var progress: [Int]? {
        return challenge.progress
    }
    
    func trackProgressForChallenge(id: String, toDos: [Int]) {
        <#code#>
    }
    
    func trackProgressForChallenge(id: String, repetitions: Float) {
        <#code#>
    }
    
}
