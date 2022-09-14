//
//  HistoryCell.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 10.09.2022.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let identifier = String(describing: ToDoCell.self)
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!


    func fill(with entry: HistoryEntry) {
        guard let challengeIndex = ChallengesDataSource.shared.challenges.firstIndex(where: {$0.id == entry.challengeID }) else { return }
        let challenge = ChallengesDataSource.shared.challenges[challengeIndex]
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "d MMM .yy"
        dateFormatterGet.locale = .current
        dateLabel.text = dateFormatterGet.string(from: entry.date)
        titleLabel.text = challenge.title
        scoreLabel.text = entry.success ? String(challenge.difficulty.reward()) : String(challenge.failFee.fee())
        scoreLabel.textColor = entry.success ? .green : .red
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
