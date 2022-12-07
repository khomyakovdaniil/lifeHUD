//
//  UserHistory.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 09.09.2022.
//

import Foundation
import Alamofire

struct HistoryEntry: Codable {
    let date: Date
    let challengeID: String
    let success: Bool
}

struct DayStats: Codable, Equatable {
    let challengeID: String
    let success: Bool
}

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
        let url = URL(string: APIHelper.historyURL)!
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
        let url = URL(string: APIHelper.historyURL)!
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
