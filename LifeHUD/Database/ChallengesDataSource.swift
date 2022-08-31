//
//  ChallengesDataSource.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation
import UIKit

protocol DataSourceDelegateProtocol: AnyObject {
    func challengeListUpdated()
}

class ChallengesDataSource: NSObject {
    
    static let shared = ChallengesDataSource()
    
    // MARK: - Properties
    
    weak var delegate: DataSourceDelegateProtocol?
    
    var challenges: [Challenge] = [Challenge()] {
        didSet {
            let activeChallenges = filter(challenges) // checks for active and failed challenges
            sort(activeChallenges) // Sorts challenges for tableView
            ChallengesRepository.saveDatabase(challenges) //  Synchronises with remote database
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
            challenge.startDate < Date()
        }
        let failed = active.filter() { challenge in
            challenge.dueDate < Date() && challenge.startDate < Date()
        }
        let restarted = failed.map() {
            updateDueDate($0)
        }
        let expired = active.filter() { challenge in
            challenge.endDate < Date()
        }
        for challenge in failed {
            UserStats.removeXP(from: challenge)
        }
        for challenge in expired {
            ChallengesRepository.removeChallenge(challenge.id)
        }
        return active
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
        ChallengesRepository.updateChallenge(newChallenge)
        return newChallenge
    }
    
    // MARK: - Literals
    let dailyTasksSectionHeader = "Ежедневные задания"
    let weeklyTasksSectionHeader = "Задания на неделю"
    let monthlyTasksSectionHeader = "Задания на месяц"
}

    // MARK: - TableView datasource

extension ChallengesDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dailyChallenges.count
        case 1:
            return weeklyChallenges.count
        case 2:
            return monthlyChallenges.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeCell.identifier) as! ChallengeCell
        let challenge = challenge(for: indexPath)
        cell.fill(with: challenge) // Fills the cell with challenge info
        return cell
    }
    
    private func challenge(for indexPath: IndexPath) -> Challenge {
        let index = indexPath.row
        switch indexPath.section {
        case 0:
            return dailyChallenges[index]
        case 1:
            return weeklyChallenges[index]
        case 2:
            return monthlyChallenges[index]
        default:
            return Challenge()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return dailyTasksSectionHeader
        case 1:
            return weeklyTasksSectionHeader
        case 2:
            return monthlyTasksSectionHeader
        default:
            return ""
        }
    }

}
