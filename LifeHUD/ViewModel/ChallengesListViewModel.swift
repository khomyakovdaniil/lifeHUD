//
//  ChallengesListViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 02.03.2024.
//

import Foundation
import UIKit

protocol ChallengesListViewModelProtocol {
    var challengesManager: ChallengesManagingProtocol { get }
    var challenges: [[Challenge]] { get }
    func fetchSortedChallenges(completion: @escaping () -> Void )
    func getChallengesCount(for section: Int) -> Int
    func getChallengeCellVM(for index: IndexPath) -> ChallengeCellDisplayProtocol
    func userSelectedChallenge(at index: IndexPath, completion: @escaping (UIViewController) -> Void )
}

final class ChallengesListViewModel: ChallengesListViewModelProtocol {
    
    init(challengesManager: ChallengesManagingProtocol) {
        self.challengesManager = challengesManager
        self.challenges = [[]]
    }
    
    var challengesManager: ChallengesManagingProtocol
    
    var challenges: [[Challenge]] = []
    
    // Load challenges from manager
    func fetchSortedChallenges(completion: @escaping () -> Void) {
        challengesManager.fetchChallenges() { [weak self] _ in
            guard let self = self else { return }
            self.challenges = [self.challengesManager.dailyChallenges,
                                self.challengesManager.weeklyChallenges,
                                self.challengesManager.monthlyChallenges]
            completion()
        }
    }
    
    // Number of challenges in section
    func getChallengesCount(for section: Int) -> Int {
        guard challenges.count > section else { return 0 }
        return challenges[section].count
    }
    
    // View model for cell
    func getChallengeCellVM(for index: IndexPath) -> ChallengeCellDisplayProtocol {
        let challenge = challenges[index.section][index.row]
        let vm = ChallengeCellViewModel(challenge: challenge) // TODO: find a way to remove dependency
        return vm
    }
    
    // Returns full info viewController for chosen challenge
    func userSelectedChallenge(at index: IndexPath, completion: @escaping (UIViewController) -> Void) {
        guard index.section < challenges.count,
              index.row < challenges[index.section].count else {
            return
        }
        let challenge = challenges[index.section][index.row]
        let challengeFullInfoVC = ChallengeFullInfoViewController(challenge: challenge, challengesManager: challengesManager)
        challengeFullInfoVC.modalPresentationStyle = .fullScreen
        completion(challengeFullInfoVC)
    }
    
}
