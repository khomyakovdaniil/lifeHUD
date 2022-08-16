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
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var difficultyLabel: UILabel!
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
        fillCategoryLabel(with: challenge.category)
        fillDifficultyLabel(with: challenge.difficulty)
    }
    
    private func fillDifficultyLabel(with difficulty: ChallengeDifficulty) {
        switch difficulty {
            
        case .lowest:
            difficultyLabel.text = "Не перетрудился?"
        case .low:
            difficultyLabel.text = "Вижу каплю пота"
        case .average:
            difficultyLabel.text = "Уже что-то!"
        case .high:
            difficultyLabel.text = "Умеешь, могёшь"
        case .highest:
            difficultyLabel.text = "КРАСАВЧИК!"
        }
    }
    private func fillCategoryLabel(with category: ChallengeCategory) {
        switch category {
            case .health:
            categoryLabel.text = "Здоровье"
            case .discipline:
            categoryLabel.text = "Дисциплина"
            case .work:
            categoryLabel.text = "Работа"
        }
        
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
            setupCheckboxTableView()
        }
    }

    private func fillDescriptionLabel(with description: String) {
        descriptionLabel.text = description
    }
    
    private func setupCheckboxTableView() {
        let bundle = Bundle.main
        let toDoCellNib = UINib(nibName: "ToDoCell", bundle: bundle)
        checkBoxTableView.register(toDoCellNib, forCellReuseIdentifier: ToDoCell.identifier)
        checkBoxTableView.delegate = self
        checkBoxTableView.dataSource = self
    }
}

extension ChallengeFullInfoViewController: UITableViewDelegate {
    
}

extension ChallengeFullInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenge.toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier) as! ToDoCell
        cell.titleLabel.text = challenge.toDos[indexPath.row]
        return cell
    }
}
