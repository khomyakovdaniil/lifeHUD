//
//  ChallengesRepository.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation
import FirebaseDatabase
import UIKit

class ChallengesRepository {
    
    static let database = Database.database().reference()
    
    static func saveDatabase(_ challenges:[Challenge]) {
        let dispatchGroup = DispatchGroup()
        for challenge in challenges {
            dispatchGroup.enter()
            let challengeObject = makeObjectWith(challenge)
            database.child("\(challenge.id)").setValue(challengeObject)
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            let ids = challenges.map() { $0.id }
                updateChallengeList(add: ids)
        }
    }
    
    static func removeChallenge(_ id: String) {
        database.child("\(id)").setValue(nil)
    }
    
    static func loadChallenges() {
        database.child("list").observeSingleEvent(of: .value) { snapshot in
            guard let values = snapshot.value as? [String] else {
                return
            }
            var challenges: [Challenge] = []
            let group = DispatchGroup()
            for challengeId in values {
                group.enter()
                database.child(challengeId).observeSingleEvent(of: .value) { snapshot in
                    guard let value = snapshot.value as? [String: Any] else {
                        group.leave()
                        return
                    }
                    print("challenge is \(value)")
                    let newChallenge = makeChallengeObject(with: value, and: challengeId)
                    challenges.append(newChallenge)
                    group.leave()
            }
        }
            group.notify(queue: .main) {
                ChallengesDataSource.shared.challenges = challenges
            }
        }
    }
    
    static func createChallenge(_ challenge: Challenge) {
        let challengeObject = makeObjectWith(challenge)
        database.child("\(challenge.id)").setValue(challengeObject)
        updateChallengeList(add: [challenge.id])
    }
    
    static func updateChallengeList(add ids: [String]) {
        database.child("list").observeSingleEvent(of: .value) { snapshot in
            print(snapshot.value!)
            guard let value = snapshot.value as? [String] else {
                database.child("list").setValue(["0": ids.first])
                return
            }
            var newValue = value
            var newIds: [String] = []
            for id in ids {
                if !value.contains(id) {
                    newIds.append(id)
                }
            }
            newValue.append(contentsOf: newIds)
            let numbers = Array(0...newValue.count-1)
            let keys = numbers.map() { String($0)}
            let dict = Dictionary(uniqueKeysWithValues: zip(keys, newValue))
            database.child("list").setValue(dict)
        }
    }
    
    private static func makeChallengeObject(with template: [String: Any], and id: String) -> Challenge {
        var newChallenge = Challenge()
        newChallenge.duration = ChallengeDuration(rawValue: template["duration"] as! Int)!
        newChallenge.category = ChallengeCategory(rawValue: template["category"] as! Int)!
        newChallenge.id = id
        newChallenge.title = template["title"] as? String ?? ""
        newChallenge.difficulty = ChallengeDifficulty(rawValue: template["difficulty"] as! Int)!
        newChallenge.description = template["description"] as? String ?? ""
        newChallenge.type = ChallengeType(rawValue: template["type"] as! Int)!
        newChallenge.count = template["count"] as? Int ?? 0
        newChallenge.failFee = ChallengeFee(rawValue: template["failFee"] as! Int)!
        newChallenge.toDos = template["toDos"] as? [String] ?? []
        newChallenge.progress = template["progress"] as? [Int] ?? []
        return newChallenge
    }
    
    private static func makeObjectWith(_ challenge: Challenge) -> [String: Any] {
        
        var progress: [Int] = []
        if challenge.progress != nil {
            for step in challenge.progress! {
                progress.append(step)
            }
        }
        
        let challengeObject: [String: Any]  = [
            "title": challenge.title as NSObject,
            "duration": challenge.duration.rawValue as NSObject,
            "category": challenge.category.rawValue as NSObject,
            "difficulty": challenge.difficulty.rawValue as NSObject,
            "type": challenge.type.rawValue as NSObject,
            "failFee": challenge.failFee.rawValue as NSObject,
            "description": challenge.description as NSObject,
            "count": challenge.count as NSObject,
            "toDos": challenge.toDos as NSObject,
            "progress": progress as NSObject,
        ]
        
        return challengeObject
    }
}

