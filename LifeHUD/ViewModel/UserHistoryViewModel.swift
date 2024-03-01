//
//  UserHistoryViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 01.03.2024.
//

import Foundation
import Alamofire

class UserHistory {
    
    static var history: [HistoryEntry] = [] {
        didSet {
            uploadHistory(history)
            sortHistory(history)
        }
    }
    
    static var historyDictionary: [Date: [DayStats]] = [:] {
        didSet {
            sortDictionary(historyDictionary)
        }
    }
    
    static var sortedHistoryDictionary: [Dictionary<Date, [DayStats]>.Element] = []
    
    static func uploadHistory(_ history: [HistoryEntry]) {
        let history = try? JSONEncoder().encode(history)
        let url = URL(string: ApiClient.Urls.historyURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = history
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
    static func sortDictionary(_ dictionary: [Date: [DayStats]]) {
        let sorted = dictionary.sorted() {
            $0.key > $1.key
        }
        sortedHistoryDictionary = sorted
    }
    
    static func sortHistory(_ history: [HistoryEntry]) {
        for entry in history {
            let dayStats = DayStats(challengeID: entry.challengeID, success: entry.success)
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
    
    static func loadHistory() {
        let url = URL(string: ApiClient.Urls.historyURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        AF.request(request).responseJSON { (response) in
            guard let data = response.data else {
                return
            }
            print(data)
            do {
                let history = try JSONDecoder().decode([HistoryEntry].self, from: data)
                UserHistory.history = history
            } catch {
               print(error)
            }
        }
    }
    
    static func makeEntry(challengeId: String, date: Date, success: Bool) {
        var entry = HistoryEntry(date: date, challengeID: challengeId, success: success)
        history.append(entry)
    }
}

class UserStats {
    
    static func addXP(from challenge: Challenge) {
        var reward = 0
        switch challenge.difficulty {
            case .lowest:
                reward = 5
            case .low:
                reward = 10
            case .average:
                reward = 50
            case .high:
                reward = 200
            case .highest:
                reward = 500
        }
        switch challenge.category {
        case .health:
            addHealthXP(reward)
        case .discipline:
            addDisciplineXP(reward)
        case .work:
            addWorkXP(reward)
        case .home:
            addHomeXP(reward)
        }
    }
    
    static func removeXP(from challenge: Challenge) {
        var fee = 0
        switch challenge.failFee {
        case .none:
            fee = 0
        case .normal:
            fee = 50
        case .critical:
            fee = 500
        }
        switch challenge.category {
        case .health:
            removeHealthXP(fee)
        case .discipline:
            removeDisciplineXP(fee)
        case .work:
            removeWorkXP(fee)
        case .home:
            removeHomeXP(fee)
        }
    }
    
    static func addHomeXP(_ xp: Int) {
        let oldXp = getHomeXP()
        let newXp = oldXp + xp
        setHomeXP(newXp)
    }
    
    static func addWorkXP(_ xp: Int) {
        let oldXp = getWorkXP()
        let newXp = oldXp + xp
        setWorkXP(newXp)
    }
    
    static func addDisciplineXP(_ xp: Int) {
        let oldXp = getDisciplineXP()
        let newXp = oldXp + xp
        setDisciplineXP(newXp)
    }
    
    static func addHealthXP(_ xp: Int) {
        let oldXp = getHealthXP()
        let newXp = oldXp + xp
        setHealthXP(newXp)
    }
    
    static func removeHomeXP(_ xp: Int) {
        let oldXp = getHomeXP()
        let newXp = oldXp - xp
        setHomeXP(newXp)
    }
    
    static func removeWorkXP(_ xp: Int) {
        let oldXp = getWorkXP()
        let newXp = oldXp - xp
        setWorkXP(newXp)
    }
    
    static func removeDisciplineXP(_ xp: Int) {
        let oldXp = getDisciplineXP()
        let newXp = oldXp - xp
        setDisciplineXP(newXp)
    }
    
    static func removeHealthXP(_ xp: Int) {
        let oldXp = getHealthXP()
        let newXp = oldXp - xp
        setHealthXP(newXp)
    }
    
    static func setHomeXP(_ xp: Int) {
        let defaults = UserDefaults.standard
        defaults.setValue(xp, forKey: "homeXP")
        defaults.synchronize()
    }
    
    static func setWorkXP(_ xp: Int) {
        let defaults = UserDefaults.standard
        defaults.setValue(xp, forKey: "workXP")
        defaults.synchronize()
    }
    
    static func setDisciplineXP(_ xp: Int) {
        let defaults = UserDefaults.standard
        defaults.setValue(xp, forKey: "disciplineXP")
        defaults.synchronize()
    }
    
    static func setHealthXP(_ xp: Int) {
        let defaults = UserDefaults.standard
        defaults.setValue(xp, forKey: "healthXP")
        defaults.synchronize()
    }
    
    static func getHomeXP() -> Int {
        return UserDefaults.standard.value(forKey: "homeXP") as? Int ?? 0
    }
    
    static func getWorkXP() -> Int {
        return UserDefaults.standard.value(forKey: "workXP") as? Int ?? 0
    }
    
    static func getDisciplineXP() -> Int {
        return UserDefaults.standard.value(forKey: "disciplineXP") as? Int ?? 0
    }
    
    static func getHealthXP() -> Int {
        return UserDefaults.standard.value(forKey: "healthXP") as? Int ?? 0
    }
}
