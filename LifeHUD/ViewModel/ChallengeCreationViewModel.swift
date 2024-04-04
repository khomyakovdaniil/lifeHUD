//
//  ChallengeCreationViewModel.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 27.03.2024.
//

import Foundation

protocol ChallengeCreationViewModelProtocol: AnyObject {
    func getCount(for parameter: ChallengeParameter) -> Int // TODO: Dependency
    func getText(for index: Int, of parameter: ChallengeParameter) -> String // TODO: Dependency
    func selectedItem(with index: Int, of parameter: ChallengeParameter) // TODO: Dependency
    func userEntered(text: String, for parameter: ChallengeParameter) // TODO: Dependency
    func userEntered(date: Date, for parameter: ChallengeParameter) // TODO: Dependency
    func userTappedCreateButton()
}


final class ChallengeCreationViewModel: ChallengeCreationViewModelProtocol {
    
    init(challenge: Challenge = Challenge(), challengesManager: ChallengesManagingProtocol) {
        self.challenge = challenge
        self.challengesManager = challengesManager
    }
    
    private var challenge: Challenge
    
    var challengesManager: ChallengesManagingProtocol
    
    func getCount(for parameter: ChallengeParameter) -> Int {
        switch parameter {
        case .duration:
            return ChallengeDuration.allCases.count
        case .category:
            return ChallengeCategory.allCases.count
        case .difficulty:
            return ChallengeDifficulty.allCases.count
        case .type:
            return ChallengeType.allCases.count
        case .failFee:
            return ChallengeFee.allCases.count
        default:
            return 0
        }
    }
    
    func getText(for index: Int, of parameter: ChallengeParameter) -> String {
        var text = ""
        switch parameter {
        case .duration(value: let value):
            text = ChallengeDuration(rawValue: index)?.string() ?? "error"
        case .category(value: let value):
            text =  ChallengeCategory(rawValue: index)?.string() ?? "error"
        case .difficulty(value: let value):
            text =  ChallengeDifficulty(rawValue: index)?.string() ?? "error"
        case .type(value: let value):
            text =  ChallengeType(rawValue: index)?.string() ?? "error"
        case .failFee(value: let value):
            text =  ChallengeFee(rawValue: index)?.string() ?? "error"
        default:
            text = "error"
        }
        return text
    }
    
    func userEntered(date: Date, for parameter: ChallengeParameter) {
        var newParameter: ChallengeParameter
        switch parameter {
        case .startDate(value: let value):
            newParameter = .startDate(value: date)
        case .endDate(value: let value):
            newParameter = .endDate(value: date)
        default:
            return
        }
        challengesManager.editCreatableChallenge(with: newParameter)
    }
    
    
    func userEntered(text: String, for parameter: ChallengeParameter) {
        var newParameter: ChallengeParameter
        switch parameter {
        case .title(value: let value):
            newParameter = .title(value: text)
        case .description(value: let value):
            newParameter = .description(value: text)
        default:
            return
        }
        challengesManager.editCreatableChallenge(with: newParameter)
    }
    
    func selectedItem(with index: Int, of parameter: ChallengeParameter) {
        var newParameter: ChallengeParameter
        switch parameter {
        case .duration(value: let value):
            guard let newValue = ChallengeDuration(rawValue: index) else { return }
            newParameter = .duration(value: newValue)
        case .category(value: let value):
            guard let newValue = ChallengeCategory(rawValue: index) else { return }
            newParameter = .category(value: newValue)
        case .difficulty(value: let value):
            guard let newValue = ChallengeDifficulty(rawValue: index) else { return }
            newParameter = .difficulty(value: newValue)
        case .type(value: let value):
            guard let newValue = ChallengeType(rawValue: index) else { return }
            newParameter = .type(value: newValue)
        case .failFee(value: let value):
            guard let newValue = ChallengeFee(rawValue: index) else { return }
            newParameter = .failFee(value: newValue)
        default:
            return
        }
        challengesManager.editCreatableChallenge(with: newParameter)
    }
    
    func userTappedCreateButton() {
        challengesManager.saveCreatableChallenge()
    }
}
