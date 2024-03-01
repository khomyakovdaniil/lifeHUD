//
//  HistoryCell.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 10.09.2022.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let identifier = String(describing: ToDoCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!


    func fill(with entry: DayStats) {
        guard let challenge = ChallengesDataSource.shared.challenges[entry.challengeID] else {
            return
        }
        titleLabel.text = challenge.title
        scoreLabel.text = entry.success ? String(challenge.difficulty.reward()) : String(challenge.failFee.fee())
        scoreLabel.textColor = entry.success ? .green : .red
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
