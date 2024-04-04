//
//  ChallengeFullInfoViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit

class ChallengeFullInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    var challengeViewModel: ChallengeFullInfoViewModelProtocol
    
    // MARK: - Outlets
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var failButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var progressCounter: UIStepper!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var checkBoxTableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var difficultyLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        challengeViewModel.userDidTapDoneButton()
    }
    
    @IBAction func failButtonTapped(_ sender: Any) {
        challengeViewModel.userDidTapFailButton()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        challengeViewModel.userDidTapDeleteButton()
    }
    
    @IBAction func progressChanged(_ sender: Any) {
        challengeViewModel.userEntered(number: progressCounter.value)
        progressLabel.text = String(Int(progressCounter.value))
    }
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fill()
    }
    
    init(challenge: Challenge, challengesManager: ChallengesManagingProtocol) {
        self.challengeViewModel = ChallengeFullInfoViewModel(challenge: challenge, challengesManager: challengesManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UISetup
    
    func fill() {
        difficultyLabel.text = challengeViewModel.difficulty
        categoryLabel.text = challengeViewModel.category
        iconView.image = challengeViewModel.categoryImage
        rewardLabel.text = challengeViewModel.reward
        if let fee = challengeViewModel.failFee {
            feeLabel.text = fee
        } else {
            feeLabel.isHidden = true
        }
        titleLabel.text = challengeViewModel.title
        descriptionLabel.text = challengeViewModel.description
        setupProgressController()
    }
    
    private func setupProgressController() {
        switch challengeViewModel.type {
        case .singleAction:
            setupDoneButton()
        case .counter:
            setupCounter()
        case .checkbox:
            setupCheckboxTableView()
        }
    }
    
    private func setupDoneButton() {
        progressLabel.isHidden = true
        progressCounter.isHidden = true
        checkBoxTableView.isHidden = true
        doneButton.isHidden = false
    }
    
    private func setupCounter() {
        progressLabel.isHidden = false
        progressCounter.isHidden = false
        checkBoxTableView.isHidden = true
        doneButton.isHidden = true
        progressCounter.minimumValue = 0
        progressCounter.maximumValue = Double(challengeViewModel.count)
        progressCounter.value = Double(challengeViewModel.progress?.count ?? 0)
        progressLabel.text = String(Int(progressCounter.value))
    }
    
    private func setupCheckboxTableView() {
        progressLabel.isHidden = true
        progressCounter.isHidden = true
        checkBoxTableView.isHidden = false
        doneButton.isHidden = true
        let bundle = Bundle.main
        let toDoCellNib = UINib(nibName: "ToDoCell", bundle: bundle)
        checkBoxTableView.register(toDoCellNib, forCellReuseIdentifier: ToDoCell.identifier)
        checkBoxTableView.delegate = self
        checkBoxTableView.dataSource = self
    }
}

    // MARK: - Progress Table View

extension ChallengeFullInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        challengeViewModel.userDidSelectTask(at: indexPath.row)
    }
}

extension ChallengeFullInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        challengeViewModel.getNumberOfSubTasks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier) as! ToDoCell
        cell.titleLabel.text = challengeViewModel.getSubtask(for: indexPath.row)
        if challengeViewModel.progress != nil {
            cell.checkBox.isSelected = challengeViewModel.progress!.contains(indexPath.row)
        }
        return cell
    }
}
