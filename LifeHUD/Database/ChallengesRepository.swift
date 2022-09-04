//
//  ChallengesRepository.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation
import FirebaseDatabase
import UIKit
import Alamofire

class ChallengesRepository {
    
    static let database = Database.database().reference()
    
    static func saveDatabase(_ challenges:[Challenge]) {
        for challenge in challenges {
            updateChallenge(challenge) // creates or updates challenge in remote database
        }
    }
    
    static func removeChallenge(_ id: String) {
        let baseURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/challenges/"
        let path = id + ".json"
        let url = URL(string: baseURL + path)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
    static func loadChallenges() {
        let url = URL(string: "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/challenges.json")!
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
                ChallengesDataSource.shared.challenges = challenges
                }
            } catch {
               print(error)
            }
        }
    }
    
    static func createChallenge(_ challenge: Challenge) {
        let challengeData = try? JSONEncoder().encode(challenge)
        let url = URL(string: "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/challenges.json")!
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
        let baseURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/challenges/"
        let path = challenge.id + ".json"
        let url = URL(string: baseURL + path)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = challengeData
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
    static func completeChallenge(_ challenge: Challenge) {
        UserStats.addXP(from: challenge)
        self.updateStartDateAndProgress(challenge)
    }
    
    private static func updateStartDateAndProgress(_ challenge: Challenge) {
        
        var newChallenge = challenge
        
        newChallenge.progress = []
        
        switch newChallenge.duration {
        case .daily:
            newChallenge.startDate = Date().endOfDay
        case .weekly:
            newChallenge.startDate = Date().endOfWeek!
        case .monthly:
            newChallenge.startDate = Date().endOfMonth
        }
        
        ChallengesRepository.updateChallenge(newChallenge)
    }
}
