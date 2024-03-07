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
        titleLabel.text = entry.challengeTitle
        scoreLabel.text = String(entry.impact)
        scoreLabel.textColor = entry.impact > 0 ? .green : .red
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
