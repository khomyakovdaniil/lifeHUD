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
        let url = APIHelper.updateChallengeURL(for: id)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
    static func loadChallenges() {
        let url = URL(string: APIHelper.challengesURL)!
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
        let url = URL(string: APIHelper.challengesURL)!
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
        let url = APIHelper.updateChallengeURL(for: challenge.id)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = challengeData
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
}
