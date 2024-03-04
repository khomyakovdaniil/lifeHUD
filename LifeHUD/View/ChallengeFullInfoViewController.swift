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
//    var dataSource: ChallengesDataSource
    
    private var progress: [Int] {
        didSet {
            if challengeViewModel.type == .counter, progress.count == challengeViewModel.count {
                challengeCompleted()
            } else if challengeViewModel.type == .checkbox, progress.count == challengeViewModel.toDos?.count {
                challengeCompleted()
            }
        }
    }
    
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
//        saveProgress()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        challengeCompleted()
    }
    
    @IBAction func failButtonTapped(_ sender: Any) {
        challengeFailed()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteChallenge()
    }
    
    @IBAction func progressChanged(_ sender: Any) {
        progressLabel.text = String(Int(progressCounter.value))
        //        progress.append(Int(progressCounter.value))
    }
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fill()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    init(challenge: Challenge, dataSource: ChallengesDataSource) {
        self.challengeViewModel = ChallengeFullInfoViewModel(challenge: challenge)
//        self.dataSource = dataSource
        self.progress = challengeViewModel.progress ?? []
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
    
    private func challengeCompleted() {
        let alert = UIAlertController(title: "Ура", message: "Задача выполнена", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ок", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) -> Void in
            ChallengesDataSource.shared.completeChallenge(self.challengeViewModel.challengeId)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func challengeFailed() {
        let alert = UIAlertController(title: "Увы", message: "Задача провалена", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ок", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) -> Void in
            ChallengesDataSource.shared.failChallenge(self.challengeViewModel.challengeId)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteChallenge() {
        let alert = UIAlertController(title: "Удаление", message: "Задача удалена", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ок", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) -> Void in
            ChallengesRepository.shared.removeChallenge(self.challengeViewModel.challengeId)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
//    private func saveProgress() {
//        challengeViewModel.progress = progress
//        guard let index = dataSource.challenges.firstIndex(where: { $0.id == challengeViewModel.challengeId }) else { return }
//        dataSource.challenges.remove(at: index)
//        dataSource.challenges.insert(challengeViewModel, at: index)
//    }
    
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
        cell.indexPath = indexPath
        cell.delegate = self
        if challengeViewModel.progress != nil {
            cell.checkBox.isSelected = challengeViewModel.progress!.contains(indexPath.row)
        }
        return cell
    }
}

extension ChallengeFullInfoViewController: ToDoCellDelegate {
    func checkBoxSelected(at indexPath: IndexPath) {
        let actionIndex = indexPath.row
        progress.append(actionIndex)
    }
    
    func checkBoxUnselected(at indexPath: IndexPath) {
        let actionIndex = indexPath.row
        guard let index = progress.firstIndex(of: actionIndex) else { return  }
        progress.remove(at: index)
    }
}
