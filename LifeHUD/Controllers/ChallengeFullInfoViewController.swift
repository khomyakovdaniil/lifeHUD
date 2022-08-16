//
//  ChallengeFullInfoViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit

class ChallengeFullInfoViewController: UIViewController {
    
    var challenge = Challenge()
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var progressCounter: UIStepper!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var checkBoxTableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
   
    @IBAction func closeButtonTapped(_ sender: Any) {
            dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fill(with: challenge)
    }
    
    func fill(with challenge: Challenge) {
        fillIconView(with: challenge.category)
        fillRewardLabel(with: challenge.difficulty)
        fillFeeLabel(with: challenge.failFee)
        fillTitleLabel(with: challenge.title)
        fillDescriptionLabel(with: challenge.description)
        setupProgressController(with: challenge)
    }
    
    private func fillIconView(with category: ChallengeCategory) {
        switch category {
            case .health:
                iconView.image = UIImage(named: "HealthIcon")
            case .discipline:
                iconView.image = UIImage(named: "DisciplineIcon")
            case .work:
                iconView.image = UIImage(named: "WorkIcon")
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
    
    private func setupProgressController(with challenge: Challenge) {
        switch challenge.type {
        case .singleAction:
            progressLabel.isHidden = true
            progressCounter.isHidden = true
            checkBoxTableView.isHidden = true
            doneButton.isHidden = false
        case .counter:
            progressLabel.isHidden = false
            progressCounter.isHidden = false
            checkBoxTableView.isHidden = true
            doneButton.isHidden = true
        case .checkbox:
            progressLabel.isHidden = true
            progressCounter.isHidden = true
            checkBoxTableView.isHidden = false
            doneButton.isHidden = true
        }
    }
    
    private func fillDescriptionLabel(with description: String) {
        descriptionLabel.text = description
    }
}
