//
//  API helper.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 31.08.2022.
//

import Foundation
import Alamofire
import FirebaseDatabase

struct ApiClient {
    
    struct Urls {
        static let baseURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/"
        
        static let challengesURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/challenges.json"
        
        static let historyURL = "https://lifehud-3007a-default-rtdb.asia-southeast1.firebasedatabase.app/history.json"
    }
    
    
    static func removeChallenge(_ id: String) {
        let url = ApiClient.updateChallengeURL(for: id)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseJSON { (response) in

            print(response)
        }
    }
    
    // Creates a URL for specific challenge using it's id
    static func updateChallengeURL(for challengeId: String) -> URL {
        let urlString = Urls.baseURL + "challenges/" + challengeId + ".json"
        return URL(string: urlString)!
    }
}


