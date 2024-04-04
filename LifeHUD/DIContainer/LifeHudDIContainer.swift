//
//  LifeHudDIContainer.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 26.03.2024.
//

import Foundation
import UIKit

final class LifeHudDIContainer {
    
    static let shared = LifeHudDIContainer()
    
    private var services: [String: Any] = [:]
    
    func bind<Service>(service: Service.Type, resolver: @escaping (LifeHudDIContainer) -> Service) {
        let key = String(describing: Service.self)
        self.services[key] = resolver(self)
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        let key = String(describing: type)
        guard let service = services[key] as? Service else {
            fatalError("\(type) service not registered")
        }
        return service
    }
    
    static func registerDependencies() {
        shared.bind(service: ChallengesManagingProtocol.self) { resolver in
            return ChallengesManager()
        }
        
        shared.bind(service: ChallengesListViewController.self) { resolver in
            let challengesManager = resolver.resolve(ChallengesManagingProtocol.self)
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vm = ChallengesListViewModel(challengesManager: challengesManager)
            let vc = storyboard.instantiateViewController(identifier: "ChallengesListViewController", creator: { coder in
                return ChallengesListViewController(coder: coder, challengesListViewModel: vm)
            })
            return vc
        }
        
        shared.bind(service: UserStatsViewController.self) { resolver in
            let challengesManager = resolver.resolve(ChallengesManagingProtocol.self)
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(identifier: "UserStatsViewController", creator: { coder in
                return UserStatsViewController(coder: coder, challengesManager: challengesManager)
            })
            return vc
        }
        
        shared.bind(service: ChallengeCreationViewController.self) { resolver in
            let challengesManager = resolver.resolve(ChallengesManagingProtocol.self)
            let viewModel = ChallengeCreationViewModel(challengesManager: challengesManager)
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(identifier: "ChallengeCreationViewController", creator: { coder in
                return ChallengeCreationViewController(coder: coder, viewModel: viewModel)
            })
            return vc
        }
        
    }
}
