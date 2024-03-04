//
//  ChallengeFullInfoViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit

class ChallengeFullInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    var challengeViewModel: ChallengeFullInfoViewModel
    
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
        if progressCounter.isHidden == false{ // multi repetitions challenge
            let toDos = checkBoxTableView.indexPathsForSelectedRows?.map() { $0.row }
            challengeViewModel.trackProgressForChallenge(toDos: toDos ?? [])
        } else if checkBoxTableView.isHidden == false { // challenge with sub tasks
            challengeViewModel.trackProgressForChallenge(repetitions: progressCounter.value)
        } else if doneButton.isSelected {
            challengeViewModel.completeChallenge()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func failButtonTapped(_ sender: Any) {
        challengeViewModel.failChallenge()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        challengeViewModel.deleteChallenge()
    }
    
    @IBAction func progressChanged(_ sender: Any) {
        progressLabel.text = String(Int(progressCounter.value))
    }
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fill()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    init(challenge: Challenge) {
        self.challengeViewModel = ChallengeFullInfoViewModel(challenge: challenge)
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
        progressCounter.value = Double(challengeViewModel.count)
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

extension ChallengeFullInfoViewController: UITableViewDelegate {
    
}

extension ChallengeFullInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeViewModel.toDos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier) as! ToDoCell
        cell.titleLabel.text = challengeViewModel.toDos?[indexPath.row]
        if challengeViewModel.progress != nil {
            cell.checkBox.isSelected = challengeViewModel.progress!.contains(indexPath.row)
        }
        return cell
    }
}
