//
//  ChallengesDataSource.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation
import FirebaseDatabase
import UIKit
import Alamofire


protocol DataSourceDelegateProtocol: AnyObject {
    func challengeListUpdated()
}

class ChallengesRepository {
    
    static let shared = ChallengesRepository()
    
    let database = Database.database().reference()
    
    func saveDatabase(_ challenges:[Challenge]) {
        for challenge in challenges {
            updateChallenge(challenge) // creates or updates challenge in remote database
        }
    }
    
    func removeChallenge(_ id: String) {
        let url = ApiClient.updateChallengeURL(for: id)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
    func loadChallenges(_ responseHandler: @escaping (Bool) -> Void) {
        let url = URL(string: ApiClient.Urls.challengesURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        AF.request(request).responseJSON { (response) in
            guard let data = response.data else {
                return
            }
            print(data)
            do {
                let challengesList = try JSONDecoder().decode([String: Challenge].self, from: data)
                var challenges: [Challenge] = []
                let group = DispatchGroup()
                for item in challengesList {
                    group.enter()
                    var newChallenge = item.value
                    newChallenge.id = item.key
                    challenges.append(newChallenge)
                    group.leave()
                }
                group.notify(queue: .main) {
                    let challengeDictionary = Dictionary(uniqueKeysWithValues: challenges.map{ ($0.id, $0) })
                    ChallengesDataSource.shared.challenges = challengeDictionary
                responseHandler(true)
                }
            } catch {
               print(error)
            }
        }
    }
    
    func createChallenge(_ challenge: Challenge) {
        let challengeData = try? JSONEncoder().encode(challenge)
        let url = URL(string: ApiClient.Urls.challengesURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = challengeData
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
    func updateChallenge(_ challenge: Challenge) {
        let challengeData = try? JSONEncoder().encode(challenge)
        let url = ApiClient.updateChallengeURL(for: challenge.id)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = challengeData
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
}


class ChallengesDataSource: NSObject {
    
    static let shared = ChallengesDataSource()
    
    // MARK: - Properties
    
    weak var delegate: DataSourceDelegateProtocol?
    
    var challenges: [String: Challenge] = ["": Challenge()] {
        didSet {
            let activeChallenges = filter(Array(challenges.values)) // checks for active and failed challenges
            sort(activeChallenges) // Sorts challenges for tableView
            ChallengesRepository.shared.saveDatabase(Array(challenges.values)) //  Synchronises with remote database
            delegate?.challengeListUpdated() // Udpates the tableView
        }
    }
    var dailyChallenges: [Challenge] = [Challenge()]
    var weeklyChallenges: [Challenge] = [Challenge()]
    var monthlyChallenges: [Challenge] = [Challenge()]
    
    // MARK: - Private functions
    
    private func sort(_ challenges: [Challenge]) {
        dailyChallenges = challenges.filter() { $0.duration == .daily }
        weeklyChallenges = challenges.filter() { $0.duration == .weekly }
        monthlyChallenges = challenges.filter() { $0.duration == .monthly }
    }
    
    private func filter(_ challenges: [Challenge]) -> [Challenge] {
        var active = challenges.filter() { challenge in
            challenge.startDate < Date() && challenge.endDate.endOfDay > Date()
        }
        let failed = active.filter() { challenge in
            challenge.dueDate.endOfDay < Date()
        }
        for challenge in failed {
            failChallenge(challenge.id)
        }
        return active
    }
    
    func completeChallenge(_ challengeId: String) {
        guard let challenge = challenges[challengeId] else {
            return
        }
        UserStats.addXP(from: challenge)
        UserHistory.makeEntry(challengeId: challenge.id, date: Date(), success: true)
        let newChallenge = self.updateStartDateDueDateAndProgress(challenge)
        updateChallenge(newChallenge)
        
    }
    
    func failChallenge(_ challengeId: String) {
        guard let challenge = challenges[challengeId] else {
            return
        }
        UserStats.removeXP(from: challenge)
        UserHistory.makeEntry(challengeId: challenge.id, date: challenge.dueDate, success: false)
        let newChallenge = self.updateDueDate(challenge)
        updateChallenge(newChallenge)
    }
    
    private func updateChallenge(_ challenge: Challenge) {
        challenges[challenge.id] = challenge
        ChallengesRepository.shared.updateChallenge(challenge)
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
    
    // MARK: - Literals
    let dailyTasksSectionHeader = "Ежедневные задания"
    let weeklyTasksSectionHeader = "Задания на неделю"
    let monthlyTasksSectionHeader = "Задания на месяц"
}

    // MARK: - TableView datasource


