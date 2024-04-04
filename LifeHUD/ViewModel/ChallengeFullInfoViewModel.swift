//
//  ChallengeFullInfoViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 01.03.2024.
//

import Foundation
import UIKit

typealias ChallengeFullInfoViewModelProtocol = ChallengeFullInfoDisplayProtocol & ProgressTrackingProtocol
    
protocol ChallengeFullInfoDisplayProtocol { // All the info required to display challenge full info
    var title: String { get }
    var description: String { get }
    var categoryImage: UIImage { get }
    var reward: String { get }
    var failFee: String? { get }
    var progress: [Int]? { get }
    var difficulty: String { get }
    var category: String { get }
    var type: ChallengeType { get } // TODO: dependency
    var duration: String { get }
    var count: Int { get }
    func getNumberOfSubTasks() -> Int
    func getSubtask(for index: Int) -> String
}

protocol ProgressTrackingProtocol { // Behavior required to track progress
    var challengesManager: ChallengesManagingProtocol { get }
    var challengeId: String { get }
    func userDidSelectTask(at index: Int)
    func userEntered(number repetitions: Double)
    func userDidTapDoneButton()
    func userDidTapFailButton()
    func userDidTapDeleteButton()
}

struct ChallengeFullInfoViewModel: ChallengeFullInfoViewModelProtocol {
    
    var challengesManager: ChallengesManagingProtocol
    
    private var challenge: Challenge
    
    init(challenge: Challenge, challengesManager: ChallengesManagingProtocol) {
        self.challenge = challenge
        self.challengesManager = challengesManager
    }
    
    // MARK: - ChallengeFullInfoDisplayProtocol
    
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
    
    // MARK: -  ProgressTrackingProtocol
    
    func userDidSelectTask(at index: Int) {
        var progress: [Int] = self.progress ?? []
            if !progress.contains(index) {
                progress.append(index)
            } else {
                let indx = progress.firstIndex(of: index)!
                progress.remove(at: indx)
            }
        let progressParameter: ChallengeParameter = .progress(value: progress)
        if progress.count == toDos?.count {
            challengesManager.completeChallenge(challengeId: challengeId, success: true)
        } else {
            challengesManager.editChallenge(challengeId: challengeId, with: [progressParameter])
        }
    }
    
    func userDidTapDoneButton() {
        challengesManager.completeChallenge(challengeId: challengeId, success: true)
    }
    
    func getNumberOfSubTasks() -> Int {
        challenge.toDos?.count ?? 0
    }
    
    func getSubtask(for index: Int) -> String {
        challenge.toDos?[index] ?? ""
    }
    
    func userEntered(number repetitions: Double) {
        let progressArray = Array(repeating: 1, count: Int(repetitions))
        let progressParameter: ChallengeParameter = .progress(value: progressArray)
        if progressArray.count == toDos?.count {
            challengesManager.completeChallenge(challengeId: challengeId, success: true)
        } else {
            challengesManager.editChallenge(challengeId: challengeId, with: [progressParameter])
        }
    }
    
    func userDidTapFailButton() {
        challengesManager.completeChallenge(challengeId: challengeId, success: false)
    }
    
    func userDidTapDeleteButton() {
        challengesManager.deleteChallenge(challengeId: challengeId)
    }
}
