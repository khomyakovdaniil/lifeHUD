//
//  UserHistoryViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 01.03.2024.
//

import Foundation

protocol HistoryManagingProtocol { // Behavior required to manage history of completed and failed challenges
    func fetchHistory(sync: Bool)
    func add(entry: HistoryEntry)
}

class StatsManager: HistoryManagingProtocol {
    
    func fetchHistory(sync: Bool) {
        NetworkManager.fetchRemoteHistory()
    }
    
    var history: [HistoryEntry] = [] {
        didSet {
            NetworkManager.uploadHistory(history)
            sortHistory(history)
        }
    }
    
    var historyDictionary: [Date: [DayStats]] = [:] {
        didSet {
            sortDictionary(historyDictionary)
        }
    }
    
    var sortedHistoryDictionary: [Dictionary<Date, [DayStats]>.Element] = []
    
    func handleChallengeResult(challenge: Challenge, success: Bool) {
        let impact = success ? challenge.difficulty.reward() : -(challenge.failFee.fee())
        applyPoints(challengeCategory: challenge.category, impact: impact)
        let date = success ? Date() : challenge.dueDate // Challenge completed now or failed until due date)
        let entry = HistoryEntry(date: date, stats: DayStats(challengeTitle: challenge.title, impact: impact))
        add(entry: entry)
    }
    
    func sortDictionary(_ dictionary: [Date: [DayStats]]) {
        let sorted = dictionary.sorted() {
            $0.key > $1.key
        }
        sortedHistoryDictionary = sorted
    }
    
    func sortHistory(_ history: [HistoryEntry]) {
        for entry in history {
            let dayStats = entry.stats
            let date = entry.date.startOfDay
            if let stats = historyDictionary[date] {
                if !stats.contains(where: {$0 == dayStats}) {
                    historyDictionary[date]?.append(dayStats)
                }
            } else {
                historyDictionary[date] = [dayStats]
            }
        }
    }
    
    func add(entry: HistoryEntry) {
        history.append(entry)
    }
    
    // - MARK: Private functions
    
    private func applyPoints(challengeCategory: ChallengeCategory, impact: Int) {
        let key = challengeCategory.xpStorageKey()
        let defaults = UserDefaults.standard
        let currentXP = defaults.value(forKey: key) as? Int ?? 0
        let newXP = currentXP + impact
        defaults.setValue(newXP, forKey: key)
    }
}
