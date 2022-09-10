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

class UserHistory {
    
    static var history: [HistoryEntry] = [] {
        didSet {
            uploadHistory(history)
        }
    }
    
    static func uploadHistory(_ history: [HistoryEntry]) {
        let challengeData = try? JSONEncoder().encode(history)
        let url = URL(string: "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/history.json")!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = challengeData
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
    static func makeEntry(challengeId: String, date: Date, success: Bool) {
        var entry = HistoryEntry(date: date, challengeID: challengeId, success: success)
        history.append(entry)
    }
}
