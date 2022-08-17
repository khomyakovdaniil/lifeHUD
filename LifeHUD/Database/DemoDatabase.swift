//
//  DemoDatabase.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import Foundation

class DemoDatabase {
    
    static func getChallenges() -> [Challenge] {
        
        var dailyChallenge = Challenge()
        dailyChallenge.duration = .daily
        dailyChallenge.category = .discipline
        dailyChallenge.id = "000001"
        dailyChallenge.title = "Медитация"
        dailyChallenge.difficulty = .low
        dailyChallenge.description = "Медитируй не менее 3 минут"
        dailyChallenge.type = .singleAction
        
        var weeklyChallenge = Challenge()
        weeklyChallenge.duration = .weekly
        weeklyChallenge.category = .health
        weeklyChallenge.id = "111001"
        weeklyChallenge.title = "Спортзал"
        weeklyChallenge.difficulty = .average
        weeklyChallenge.description = "Две силовых тренировки в спортзале или на уличных тренажерах"
        weeklyChallenge.type = .counter
        weeklyChallenge.count = 2
        weeklyChallenge.failFee = .normal
        
        
        var monthlyChallenge = Challenge()
        monthlyChallenge.duration = .monthly
        monthlyChallenge.category = .work
        monthlyChallenge.id = "222001"
        monthlyChallenge.title = "Соискатель"
        monthlyChallenge.difficulty = .high
        monthlyChallenge.description = "Предпринять следущие шаги для поиска работы"
        monthlyChallenge.type = .checkbox
        monthlyChallenge.failFee = .critical
        monthlyChallenge.toDos = ["Написать демо для GitHub", "Обновить резюме", "Откликнуться на 30 вакансий"]
        
        var monthlyChallenge2 = Challenge()
        monthlyChallenge2.duration = .monthly
        monthlyChallenge2.category = .work
        monthlyChallenge2.id = "222002"
        monthlyChallenge2.title = "Успешный соискатель"
        monthlyChallenge2.difficulty = .highest
        monthlyChallenge2.description = "Получить работу"
        monthlyChallenge2.type = .singleAction
        monthlyChallenge2.failFee = .none
       
        let challenges = [dailyChallenge, weeklyChallenge, monthlyChallenge, monthlyChallenge2] 
        
        return challenges
    }
  
}
