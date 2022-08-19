//
//  UserStats.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 18.08.2022.
//

import Foundation

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
