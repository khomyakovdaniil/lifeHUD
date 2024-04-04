//
//  ChallengesDataSource.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation
import UIKit

protocol ChallengesManagingProtocol { // Behavior required to manage challenges Database
    func fetchChallenges(responseHandler: ((Bool) -> Void)?)
    func saveCreatableChallenge()
    func editChallenge(challengeId: String, with parameters: [ChallengeParameter])
    func completeChallenge(challengeId: String, success: Bool)
    func deleteChallenge(challengeId: String)
    func editCreatableChallenge(with parameter: ChallengeParameter)
    var dailyChallenges: [Challenge] { get }
    var weeklyChallenges: [Challenge] { get }
    var monthlyChallenges: [Challenge] { get }
    var userStatsManager: StatsManager { get }
}

protocol SortedChallengesProviderProtocol {
    func fetchSortedChallenges(responseHandler: ((Bool) -> Void)?)
}

class ChallengesManager: ChallengesManagingProtocol {
    
    
    // - MARK: Properies
    
    var creatableChallenge = Challenge()
    
    // User stats and history manager
    let userStatsManager = StatsManager()
    
    // Dictionary of challenges with IDs as keys. On didSet checks for active challenges and sorts them by duration (daily, weekly, monthly)
    var challenges: [String: Challenge] = ["": Challenge()] {
        didSet {
            let activeChallenges = filterActive(Array(challenges.values)) // checks for active and failed challenges
            sort(activeChallenges) // Sorts challenges for tableView
        }
    }
    
    // Arrays of active challenges sorted by duration
    var dailyChallenges: [Challenge] = [Challenge()]
    var weeklyChallenges: [Challenge] = [Challenge()]
    var monthlyChallenges: [Challenge] = [Challenge()]
    
    // - MARK: Functions
    
    // Fetches challenges from remote server
    func fetchChallenges(responseHandler: ((Bool) -> Void)?) {
        NetworkManager.fetchRemoteChallenges(responseHandler: { [weak self] challengesDictionary in
            guard let self else { return }
            self.challenges = challengesDictionary
            if let responseHandler {
                responseHandler(true)
            }
        })
    }
    
    // Fetches challenges from remote server (used in ChallengesListViewController)
    func fetchSortedChallenges(responseHandler: ((Bool) -> Void)?) {
        fetchChallenges(responseHandler: responseHandler)
    }
    
    // Challenge completed or failed
    func completeChallenge(challengeId: String, success: Bool) {
        
        // Gets challenge from storage by id
        guard let challenge = challenges[challengeId] else {
            return
        }
        // Sends challenge completion result to user stats manager
        userStatsManager.handleChallengeResult(challenge: challenge, success: success)
        
        // Sets new dates for challenge and uploads it to remote database for future use (All challenges are considered repetative)
        let newChallenge = self.updateStartDateDueDateAndProgress(challenge)
        NetworkManager.updateChallenge(newChallenge)
    }
    
    func saveCreatableChallenge() {
        var dueDateParameter: ChallengeParameter
        switch creatableChallenge.duration {
        case .daily:
            dueDateParameter = .dueDate(value: creatableChallenge.startDate.endOfDay)
        case .weekly:
            dueDateParameter = .dueDate(value: creatableChallenge.startDate.endOfWeek!)
        case .monthly:
            dueDateParameter = .dueDate(value: creatableChallenge.startDate.endOfMonth)
        }
        let id = String(Int.random(in: 100000..<999999))
        var idParameter: ChallengeParameter = .id(value: id)
        creatableChallenge.applyParameter(dueDateParameter)
        creatableChallenge.applyParameter(idParameter)
        self.challenges[id] = creatableChallenge
        NetworkManager.createChallenge(creatableChallenge)
    }
    
//    // Creates challenge based on given set of parameter
//    func createChallenge(with parameters: [ChallengeParameter]) {
//        
//        // Creates a blanc challenge template
//        var mutableChallenge = Challenge()
//        
//        // Iterates through given array of parameters and applies them to template
//        let dGroup = DispatchGroup()
//        for parameter in parameters {
//            dGroup.enter()
//            mutableChallenge.applyParameter(parameter)
//            dGroup.leave()
//        }
//        
//        // After all the parameters are applied adds challenge to array and uploads it to remote server
//        dGroup.notify(queue: .main) {
//            self.challenges[mutableChallenge.id] = mutableChallenge
//            NetworkManager.createChallenge(mutableChallenge)
//        }
//    }
    
    // Edits challenge with given set of parameters
    func editChallenge(challengeId: String, with parameters: [ChallengeParameter]) {
        
        // Checks if the challenge for given ID exists
        guard let challenge = challenges[challengeId] else { return }
        
        // Creates a template based on existing challenge
        var mutableChallenge = challenge
        
        // Iterates through given array of parameters and applies them to template
        let dGroup = DispatchGroup()
        for parameter in parameters {
            dGroup.enter()
            mutableChallenge.applyParameter(parameter)
            dGroup.leave()
        }
        
        // After all the parameters are applied repalces the initial challenge with edited template and updates it on remote server
        dGroup.notify(queue: .main) {
            self.challenges[challengeId] = mutableChallenge
            NetworkManager.updateChallenge(mutableChallenge)
        }

    }
    
    // Edits challenge with given set of parameters
    func editCreatableChallenge(with parameter: ChallengeParameter) {
        creatableChallenge.applyParameter(parameter)
    }
    
    // Removes challenge from stored array and from remote server
    func deleteChallenge(challengeId: String) {
        self.challenges[challengeId] = nil
        NetworkManager.removeChallenge(challengeId)
    }

    // - MARK: Private functions
    
    // Sets up new dates and clears progress for challenge (All challenges are considered repetative)
    private func updateStartDateDueDateAndProgress(_ challenge: Challenge) -> Challenge {
        
        // Create a template based on existing challenge
        var newChallenge = challenge
        
        // Clears progress
        newChallenge.progress = []
        
        // Sets up new dates according to challenge duration
        var dateComponent = DateComponents()
        switch newChallenge.duration {
        case .daily:
            newChallenge.startDate = Date().endOfDay
            dateComponent.day = 1
        case .weekly:
            newChallenge.startDate = Date().endOfWeek!
            dateComponent.day = 7
        case .monthly:
            newChallenge.startDate = Date().endOfMonth
            dateComponent.month = 1
        }
        newChallenge.dueDate = Calendar.current.date(byAdding: dateComponent, to: newChallenge.startDate)!
        
        
        return newChallenge
    }
    
    // Divides a common array of challenges into 3 arrays by duration
    private func sort(_ challenges: [Challenge]) {
        dailyChallenges = challenges.filter() { $0.duration == .daily }
        weeklyChallenges = challenges.filter() { $0.duration == .weekly }
        monthlyChallenges = challenges.filter() { $0.duration == .monthly }
    }
    
    // Checks for active challenges to use, failed challenges to apply to stats and expired challenges to delete
    private func filterActive(_ challenges: [Challenge]) -> [Challenge] {
        //Checks for challenges which start before the current date and end after it
        let active = challenges.filter() { challenge in
            challenge.startDate < Date() && challenge.endDate.endOfDay > Date()
        }
        // Checks for challenges which dueDate is before the current date, hence they are failed
        let failed = active.filter() { challenge in
            challenge.dueDate.endOfDay < Date()
        }
        // Sends all the failed challenges to completion function to track XP and create challenges with new dates (All challenges are considered repetetive)
        for challenge in failed {
            completeChallenge(challengeId: challenge.id, success: false)
        }
        // Checks for challenges which endDate is before current date, hence they are expired
        let expired = challenges.filter() { challenge in
            challenge.endDate.endOfDay < Date()
        }
        // Expired challenges are deleted from database
        for challenge in expired {
            deleteChallenge(challengeId: challenge.id)
        }
        // Returns only active challenges
        return active
    }
    
}
