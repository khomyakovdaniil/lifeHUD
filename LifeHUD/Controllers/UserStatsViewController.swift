//
//  UserStatsViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 18.08.2022.
//

import UIKit

class UserStatsViewController: UIViewController {
    
    
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthLabel.text = String(UserStats.getHealthXP())
        workLabel.text = String(UserStats.getWorkXP())
        disciplineLabel.text = String(UserStats.getDisciplineXP())
        homeLabel.text = String(UserStats.getHomeXP())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        healthLabel.text = String(UserStats.getHealthXP())
        workLabel.text = String(UserStats.getWorkXP())
        disciplineLabel.text = String(UserStats.getDisciplineXP())
        homeLabel.text = String(UserStats.getHomeXP())
    }

}
