//
//  ChallengesDataSource.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation
import UIKit

protocol ChallengeManagingProtocol { // Behavior required to manage challenges Database
    func fetchChallenges(responseHandler: ((Bool) -> Void)?) // Sync parameter to fetch from internet server
    func createChallenge(with parameters: [ChallengeParameters])
    func editChallenge(challengeId: String, with parameters: [ChallengeParameters])
    func completeChallenge(challengeId: String)
    func failChallenge(challengeId: String)
    func deleteChallenge(challengeId: String)
}

protocol SortedChallengesProviderProtocol {
    func fetchSortedChallenges(responseHandler: ((Bool) -> Void)?)
}

class ChallengesManager: ChallengeManagingProtocol, SortedChallengesProviderProtocol {
    
    static let shared = ChallengesManager()
    
    let userStatsManager = StatsManager()
    
    var challenges: [String: Challenge] = ["": Challenge()] {
        didSet {
            let activeChallenges = filterActive(Array(challenges.values)) // checks for active and failed challenges
            sort(activeChallenges) // Sorts challenges for tableView
        }
    }
    
    var dailyChallenges: [Challenge] = [Challenge()]
    var weeklyChallenges: [Challenge] = [Challenge()]
    var monthlyChallenges: [Challenge] = [Challenge()]
    
    func fetchChallenges(responseHandler: ((Bool) -> Void)?) {
        NetworkManager.fetchRemoteChallenges(responseHandler: responseHandler)
    }
    
    func fetchSortedChallenges(responseHandler: ((Bool) -> Void)?) {
        fetchChallenges(responseHandler: responseHandler)
    }
    
    func completeChallenge(challengeId: String) {
        guard let challenge = challenges[challengeId] else {
            return
        }
        userStatsManager.handleChallengeResult(challenge: challenge, success: true)
        let newChallenge = self.updateStartDateDueDateAndProgress(challenge)
        NetworkManager.updateChallenge(newChallenge)
    }
    
    func failChallenge(challengeId: String) {
        guard let challenge = challenges[challengeId] else {
            return
        }
        userStatsManager.handleChallengeResult(challenge: challenge, success: false)
        let newChallenge = self.updateDueDate(challenge)
        NetworkManager.updateChallenge(newChallenge)
    }
    
    func createChallenge(with parameters: [ChallengeParameters]) {
        var mutableChallenge = Challenge()
        let dGroup = DispatchGroup()
        for parameter in parameters {
            dGroup.enter()
            mutableChallenge.applyParameter(parameter)
            dGroup.leave()
        }
        dGroup.notify(queue: .main) {
            self.challenges[mutableChallenge.id] = mutableChallenge
            NetworkManager.createChallenge(mutableChallenge)
        }
    }
    
    func editChallenge(challengeId: String, with parameters: [ChallengeParameters]) {
        guard let challenge = challenges[challengeId] else { return }
        var mutableChallenge = challenge
        let dGroup = DispatchGroup()
        for parameter in parameters {
            dGroup.enter()
            mutableChallenge.applyParameter(parameter)
            dGroup.leave()
        }
        dGroup.notify(queue: .main) {
            self.challenges[challengeId] = mutableChallenge
            NetworkManager.updateChallenge(mutableChallenge)
        }

    }
    
    func deleteChallenge(challengeId: String) {
        NetworkManager.removeChallenge(challengeId)
    }
    
    func fetchSortedChallenges(sync: Bool = false, responseHandler: ((Bool) -> Void)?) {
        NetworkManager.fetchRemoteChallenges(responseHandler: responseHandler)
    }
    
    // - MARK: Private functions
    
    private func updateStartDateDueDateAndProgress(_ challenge: Challenge) -> Challenge {
        
        var newChallenge = challenge
        
        newChallenge.progress = []
        
        switch newChallenge.duration {
        case .daily:
            newChallenge.startDate = Date().endOfDay
            var dateComponent = DateComponents()
            dateComponent.day = 1
            newChallenge.dueDate = Calendar.current.date(byAdding: dateComponent, to: newChallenge.startDate)!
        case .weekly:
            newChallenge.startDate = Date().endOfWeek!
            var dateComponent = DateComponents()
            dateComponent.day = 7
            newChallenge.dueDate = Calendar.current.date(byAdding: dateComponent, to: newChallenge.startDate)!
        case .monthly:
            newChallenge.startDate = Date().endOfMonth
            var dateComponent = DateComponents()
            dateComponent.month = 1
            newChallenge.dueDate = Calendar.current.date(byAdding: dateComponent, to: newChallenge.startDate)!
        }
        return newChallenge
    }
    
    private func updateDueDate(_ challenge: Challenge) -> Challenge {
        var newChallenge = challenge
        switch challenge.duration {
        case .daily:
            newChallenge.dueDate = Calendar.current.date(byAdding: .day, value: 1, to: challenge.dueDate)!
        case .weekly:
            newChallenge.dueDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: challenge.dueDate)!
        case .monthly:
            newChallenge.dueDate = Calendar.current.date(byAdding: .month, value: 1, to: challenge.dueDate)!
        }
        return newChallenge
    }
    
    private func sort(_ challenges: [Challenge]) {
        dailyChallenges = challenges.filter() { $0.duration == .daily }
        weeklyChallenges = challenges.filter() { $0.duration == .weekly }
        monthlyChallenges = challenges.filter() { $0.duration == .monthly }
    }
    
    private func filterActive(_ challenges: [Challenge]) -> [Challenge] {
        var active = challenges.filter() { challenge in
            challenge.startDate < Date() && challenge.endDate.endOfDay > Date()
        }
        let failed = active.filter() { challenge in
            challenge.dueDate.endOfDay < Date()
        }
        for challenge in failed {
            failChallenge(challengeId: challenge.id)
        }
        let expired = challenges.filter() { challenge in
            challenge.endDate.endOfDay < Date()
        }
        for challenge in expired {
            deleteChallenge(challengeId: challenge.id)
        }
        return active
    }
    
}
