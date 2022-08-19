//
//  ChallengeCell.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit

class ChallengeCell: UITableViewCell {
    
    static let identifier = String(describing: ChallengeCell.self)
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    
    
    func fill(with challenge: Challenge) {
        fillIconView(with: challenge.category)
        fillRewardLabel(with: challenge.difficulty)
        fillFeeLabel(with: challenge.failFee)
        fillTitleLabel(with: challenge.title)
        setupProgressView(with: challenge)
    }
    
    private func fillIconView(with category: ChallengeCategory) {
        switch category {
            case .health:
                iconView.image = UIImage(named: "HealthIcon")
            case .discipline:
                iconView.image = UIImage(named: "DisciplineIcon")
            case .work:
                iconView.image = UIImage(named: "WorkIcon")
        case .home:
            iconView.image = UIImage(named: "HomeIcon")
        }
    }
    
    private func fillRewardLabel(with difficulty: ChallengeDifficulty) {
        var reward = 0
        switch difficulty {
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
        rewardLabel.text = "+ \(reward) XP"
    }
    
    private func fillFeeLabel(with failFee: ChallengeFee) {
        var fee = 0
        switch failFee {
        case .none:
            feeLabel.isHidden = true
        case .normal:
            fee = 50
        case .critical:
            fee = 500
        }
        feeLabel.text = "- \(fee) XP"
    }
    
    private func fillTitleLabel(with title: String) {
        titleLabel.text = title
    }
    
    private func setupProgressView(with challenge: Challenge) {
        var current = Float(0)
        if let progress = challenge.progress {
            current = Float(progress.count)
        }
        switch challenge.type {
        case .singleAction:
            progressView.isHidden = true
        case .counter:
            progressView.isHidden = false
            goalLabel.text = String(challenge.count)
            let maximum = Float(challenge.count)
            let progress = current/maximum
            progressBar.setProgress(progress, animated: true)
        case .checkbox:
            progressView.isHidden = false
            goalLabel.text = String(challenge.toDos.count)
            let maximum = Float(challenge.toDos.count)
            let progress = current/maximum
            progressBar.setProgress(progress, animated: true)
        }
    }
}
