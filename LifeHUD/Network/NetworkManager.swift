//
//  API helper.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 31.08.2022.
//

import Foundation
import Alamofire
import FirebaseDatabase

struct NetworkManager {
    
    struct Urls {
        static let baseURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/"
        
        static let challengesURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/challenges.json"
        
        static let historyURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/history.json"
        
    }
    
    // - MARK: Challenges
    
    // Returns a URL for specific challenge using it's id
    static func updateChallengeURL(for challengeId: String) -> URL {
        let urlString = Urls.baseURL + "challenges/" + challengeId + ".json"
        return URL(string: urlString)!
    }
    
    static func fetchRemoteChallenges(responseHandler: (([String : Challenge]) -> Void)?) {
        let url = URL(string: NetworkManager.Urls.challengesURL)!
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
                    if let responseHandler = responseHandler {
                        responseHandler(challengeDictionary)
                    }
                }
            } catch {
               print(error)
            }
        }
    }
    
    static func createChallenge(_ challenge: Challenge) {
        let challengeData = try? JSONEncoder().encode(challenge)
        let url = URL(string: NetworkManager.Urls.challengesURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = challengeData
        AF.request(request).responseJSON { (response) in
            print(response)
        }
    }
    
    static func updateChallenge(_ challenge: Challenge) {
        let challengeData = try? JSONEncoder().encode(challenge)
        let url = NetworkManager.updateChallengeURL(for: challenge.id)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = challengeData
        AF.request(request).responseJSON { (response) in
            print(response)
        }
    }
    
    static func removeChallenge(_ id: String) {
        let url = NetworkManager.updateChallengeURL(for: id)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseJSON { (response) in
            print(response)
        }
    }
    
    // - MARK: Stats and history
    
    static func fetchRemoteHistory() {
        let url = URL(string: NetworkManager.Urls.historyURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        AF.request(request).responseJSON { (response) in
            guard let data = response.data else {
                return
            }
            print(data)
            do {
                let history = try JSONDecoder().decode([HistoryEntry].self, from: data)
//                ChallengesManager.shared.userStatsManager.history = history
            } catch {
               print(error)
            }
        }
    }
    
    static func uploadHistory(_ history: [HistoryEntry]) {
        let history = try? JSONEncoder().encode(history)
        let url = URL(string: NetworkManager.Urls.historyURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = history
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
}


