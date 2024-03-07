//
//  UserHistoryViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 01.03.2024.
//

import Foundation

protocol HistoryManagingProtocol { // Behavior required to manage history of completed and failed challenges
    func fetchHistory(sync: Bool)
    func handleChallengeResult(challenge: Challenge, success: Bool)
}

class StatsManager: HistoryManagingProtocol {
    
    // - MARK: Properies
    
    // Unorganised array of history entries. On didSet uploads to remote server and groups entries by date to create a history dictionary
    var history: [HistoryEntry] = [] {
        didSet {
            NetworkManager.uploadHistory(history)
            sortHistory(history)
        }
    }
    
    // History entries grouped by date
    var historyDictionary: [Date: [DayStats]] = [:] {
        didSet {
            sortDictionary(historyDictionary)
        }
    }
    
    // History dictionary sorted from earlier to most recent
    var sortedHistoryDictionary: [Dictionary<Date, [DayStats]>.Element] = []
    
    // - MARK: Functions
    
    // Fetches history from remote server
    func fetchHistory(sync: Bool) {
        NetworkManager.fetchRemoteHistory()
    }
    
    // Applies challenge completion results to user stats
    func handleChallengeResult(challenge: Challenge, success: Bool) {
        
        // Impact is reward for completed challenges and fee for failed challenges
        let impact = success ? challenge.difficulty.reward() : -(challenge.failFee.fee())
        
        // Saves impact to user stats
        applyPoints(challengeCategory: challenge.category, impact: impact)
        
        // Date is current date for completed challenges or due date for failed challenges
        let date = success ? Date() : challenge.dueDate
        
        // Creating history entry based on challenge title, date and impact
        let entry = HistoryEntry(date: date, stats: DayStats(challengeTitle: challenge.title, impact: impact))
        
        // Adding created enry to history
        add(entry: entry)
    }
    
    // - MARK: Private functions
    
    // Sorting user history dictionary by date from earlier to most recent
    private func sortDictionary(_ dictionary: [Date: [DayStats]]) {
        let sorted = dictionary.sorted() {
            $0.key > $1.key
        }
        sortedHistoryDictionary = sorted
    }
    
    // Takes array of history entries and creates a dictionary with dates as keys
    private func sortHistory(_ history: [HistoryEntry]) {
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
    
    // Applies challenge result points to relevant category. All points are stored in UserDefaults
    private func applyPoints(challengeCategory: ChallengeCategory, impact: Int) {
        let key = challengeCategory.xpStorageKey()
        let defaults = UserDefaults.standard
        let currentXP = defaults.value(forKey: key) as? Int ?? 0
        let newXP = currentXP + impact
        defaults.setValue(newXP, forKey: key)
    }
    
    // Simply adds history entry to array
    private func add(entry: HistoryEntry) {
        history.append(entry)
    }
}
