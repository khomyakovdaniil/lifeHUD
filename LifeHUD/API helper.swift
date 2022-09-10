//
//  API helper.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 31.08.2022.
//

import Foundation

class APIHelper {
    static let baseURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/"
    
    static func updateChallengeURL(for challengeId: String) -> URL {
        let urlString = baseURL + "challenges/" + challengeId + ".json"
        return URL(string: urlString)!
    }
    
    static let challengesURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/challenges.json"
}
