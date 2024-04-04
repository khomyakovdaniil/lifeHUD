//
//  TestCreateViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 23.03.2024.
//

import Foundation


protocol TestCreateViewModelProtocol: AnyObject {
    func getDifficultyCount() -> Int
    func getTextForIndex(for index: Int) -> String
    func selectedDifficultyItem(with index: Int)
}

final class TestCreateViewModel: TestCreateViewModelProtocol {
    
    init(challenge: Challenge = Challenge(), challengeManager: ChallengesManagingProtocol) {
        self.challenge = challenge
        self.challengeManager = challengeManager
    }
    
    private var challenge: Challenge
    
    var challengeManager: ChallengesManagingProtocol
    
    func getDifficultyCount() -> Int {
        ChallengeDifficulty.allCases.count
    }
    
    func getTextForIndex(for index: Int) -> String {
        guard let text = ChallengeDifficulty(rawValue: index)?.string() else { return "error" }
        return text
    }
    
    func selectedDifficultyItem(with index: Int) {
        guard let difficulty = ChallengeDifficulty(rawValue: index) else {
            return
        }
        let parameter: ChallengeParameter = .difficulty(value: difficulty)
        challengeManager.editCreatableChallenge(with: parameter)
    }
}
