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
    var challengeManager: ChallengeManagingProtocol { get }
    var challengeId: String { get }
    func trackProgressForChallenge(toDos: [Int]) // For challenges with sub tasks
    func trackProgressForChallenge(repetitions: Double) // For multi repetitions challenges
    func completeChallenge()
    func failChallenge()
    func deleteChallenge()
}

protocol ChallengeCreationProtocol { // Behavior required to create challenge
    var challengeManager: ChallengeManagingProtocol { get }
    func createChallenge()
}

struct ChallengeFullInfoViewModel: ChallengeFullInfoDisplayProtocol, ProgressTrackingProtocol {
    
    var challengeManager: ChallengeManagingProtocol
    
    private var challenge: Challenge
    
    init(challenge: Challenge) {
        self.challenge = challenge
        self.challengeManager = ChallengesManager.shared
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
        get {
            return challenge.category.string()
    }
        set {
        }
    }
    
    var categoryImage: UIImage {
        return challenge.category.image()
    }
    
    var difficulty: String {
        return challenge.difficulty.string()
    }
    
    var reward: String {
        return "+ \(challenge.difficulty.reward()) XP"
    }
    
    var type: ChallengeType {
        return challenge.type
    }
    
    var failFee: String? {
        return "- \(challenge.failFee.fee()) XP"
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
    
    func trackProgressForChallenge(toDos: [Int]) {
        let progressParameter = ChallengeParameters.progress(value: toDos)
        challengeManager.editChallenge(challengeId: challengeId, with: [progressParameter])
    }
    
    func trackProgressForChallenge(repetitions: Double) {
        let progressArray = Array(repeating: 1, count: Int(repetitions))
        let progressParameter = ChallengeParameters.progress(value: progressArray)
        challengeManager.editChallenge(challengeId: challengeId, with: [progressParameter])
    }
    
    func completeChallenge() {
        challengeManager.completeChallenge(challengeId: challengeId, success: true)
    }
    
    func failChallenge() {
        challengeManager.completeChallenge(challengeId: challengeId, success: false)
    }
    
    func deleteChallenge() {
        challengeManager.deleteChallenge(challengeId: challengeId)
    }
}
