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
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    
    
    func fill(with challenge: ChallengeViewModel) {
        iconView.image = challenge.categoryImage
        rewardLabel.text = challenge.reward
        if let fee = challenge.failFee {
            feeLabel.isHidden = false
            feeLabel.text = fee
        } else {
            feeLabel.isHidden = true
        }
        titleLabel.text = challenge.title
        if let aim = challenge.progress.aim,
           let current = challenge.progress.crrnt {
            progressView.isHidden = false
            goalLabel.text = aim
            progressBar.progress = current
        } else {
            progressView.isHidden = true
        }
    }
}
