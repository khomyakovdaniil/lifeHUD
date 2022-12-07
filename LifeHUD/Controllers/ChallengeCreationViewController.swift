//
//  ChallengeCreationViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 17.08.2022.
//

import UIKit

class ChallengeCreationViewController: UIViewController {
    
    var challenge = Challenge() {
        didSet {
            setupViews()
        }
    }
    
    @IBOutlet weak var categoryPickerButton: UIButton!
    @IBOutlet weak var durationPickerButton: UIButton!
    @IBOutlet weak var difficultyPickerButton: UIButton!
    @IBOutlet weak var failFeePickerButton: UIButton!
    @IBOutlet weak var typePickerButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var numberOfRepsField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var toDosTableView: UITableView!
    @IBOutlet weak var additionalInfoView: UIView!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var toDosView: UIView!
    @IBOutlet weak var addToDoButton: UIButton!
    @IBOutlet var additionalInfoViewIsVisibleConstraint: NSLayoutConstraint!
    @IBOutlet var additionalInfoViewIsHiddenConstraint: NSLayoutConstraint!
    
    
    private var toDos: [String] = [""]
    
    private let screenWidth = UIScreen.main.bounds.width - 10
    private let screenHeight = UIScreen.main.bounds.height / 1
    private var selectedRow = 0
    
    private var currentEditingMode: Setting?
    
    private enum Setting {
        case category
        case duration
        case fee
        case difficulty
        case type
        
        func pickerName() -> String {
            switch self {
            case .category:
                return "Выберите категорию"
            case .duration:
                return "Выберите длительность"
            case .fee:
                return "Выберите штраф за невыполнение"
            case .difficulty:
                return "Выберите сложность"
            case .type:
                return "Выберите тип"
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupKeyboardDissmisal()
    }
    
    // MARK: - UI
    
    private func setupViews() {
        setupPickerButtons()
        setupAdditionalInfoView()
        setupToDosTableView()
    }
    
    private func setupKeyboardDissmisal() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupPickerButtons() {
        setupCategoryPickerButton()
        setupDurationPickerButton()
        setupDifficultyPickerButton()
        setupFailFeePickerButton()
        setupTypePickerButton()
    }
    
    private func setupAdditionalInfoView() {
        switch challenge.type {
        case .singleAction:
            hideAdditionalInfoView()
        case .counter:
            showAdditionalInfoViewWithCounter()
        case .checkbox:
            showAdditionalInfoViewWithToDos()
        }
    }
    
    private func hideAdditionalInfoView() {
        additionalInfoView.isHidden = true
        additionalInfoViewIsVisibleConstraint.isActive = false
        additionalInfoViewIsHiddenConstraint.isActive = true
    }
    
    private func showAdditionalInfoViewWithCounter() {
        additionalInfoView.isHidden = false
        additionalInfoViewIsHiddenConstraint.isActive = false
        additionalInfoViewIsVisibleConstraint.constant = 80
        additionalInfoViewIsVisibleConstraint.isActive = true
        toDosView.isHidden = true
        counterView.isHidden = false
    }
    
    private func showAdditionalInfoViewWithToDos() {
        additionalInfoView.isHidden = false
        additionalInfoViewIsHiddenConstraint.isActive = false
        additionalInfoViewIsVisibleConstraint.constant = self.toDosTableView.contentSize.height + 35
        additionalInfoViewIsVisibleConstraint.isActive = true
        counterView.isHidden = true
        toDosView.isHidden = false
    }
    
    private func setupCategoryPickerButton() {
        let title = challenge.category.string()
        categoryPickerButton.setTitle(title, for: .normal)
    }
    
    private func setupDurationPickerButton() {
        let title = challenge.duration.string()
        durationPickerButton.setTitle(title, for: .normal)
    }
    
    private func setupDifficultyPickerButton() {
        let title = challenge.difficulty.string()
        difficultyPickerButton.setTitle(title, for: .normal)
    }
    
    private func setupFailFeePickerButton() {
        let title = challenge.failFee.string()
        failFeePickerButton.setTitle(title, for: .normal)
    }
    
    private func setupTypePickerButton() {
        let title = challenge.type.string()
        typePickerButton.setTitle(title, for: .normal)
    }
    
    private func setupToDosTableView() {
        toDosTableView.dataSource = self
        toDosTableView.delegate = self
        
        let bundle = Bundle.main
        let createToDoCellNib = UINib(nibName: "CreateToDoCell", bundle: bundle)
        toDosTableView.register(createToDoCellNib, forCellReuseIdentifier: CreateToDoCell.identifier)
    }
    
    //MARK: - Actions
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        popUpPicker(for: .category, sender: sender)
    }
    @IBAction func durationButtonTapped(_ sender: UIButton) {
        popUpPicker(for: .duration, sender: sender)
    }
    @IBAction func difficultyButtonTapped(_ sender: UIButton) {
        popUpPicker(for: .difficulty, sender: sender)
    }
    @IBAction func failFeeButtonTapped(_ sender: UIButton) {
        popUpPicker(for: .fee, sender: sender)
    }
    @IBAction func typeButtonTapped(_ sender: UIButton) {
        popUpPicker(for: .type, sender: sender)
    }
    
    private func popUpPicker(for setting: Setting, sender: UIButton) {
        currentEditingMode = setting
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        //pickerView.selectRow(selectedRowTextColor, inComponent: 1, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: setting.pickerName(), message: "", preferredStyle: .actionSheet)
        
//        alert.popoverPresentationController?.sourceView = sender
//        alert.popoverPresentationController?.sourceRect = sender.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Выбрать", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            self.edit(setting, with: self.selectedRow)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func edit(_ setting: Setting, with option: Int) {
        switch setting {
        case .category:
            challenge.category = ChallengeCategory.init(rawValue: option) ?? .health
        case .duration:
            challenge.duration = ChallengeDuration.init(rawValue: option) ?? .daily
        case .fee:
            challenge.failFee = ChallengeFee.init(rawValue: option) ?? .none
        case .difficulty:
            challenge.difficulty = ChallengeDifficulty.init(rawValue: option) ?? .lowest
        case .type:
            challenge.type = ChallengeType.init(rawValue: option) ?? .singleAction
        }
    }
    
    @IBAction func addToDoButtonTapped(_ sender: Any) {
        toDos.append("")
        toDosTableView.insertRows(at: [IndexPath(row: toDos.count-1, section: 0)], with: .none)
        additionalInfoViewIsVisibleConstraint.constant = self.toDosTableView.contentSize.height + 35
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard let title = titleField.text,
              title != "",
              let description = descriptionField.text,
              description != ""
        else { return }
        var count = 0
        var toDos: [String] = []
        if challenge.type == .counter {
            guard let number = numberOfRepsField.text, number != "0" else { return }
            count = Int(number) ?? 1
        } else if challenge.type == .checkbox {
            toDos = self.toDos ?? [""]
        }
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        var dueDate = Date()
        switch challenge.duration {
        case .daily:
            dueDate = startDate.endOfDay
        case .weekly:
            dueDate = startDate.endOfWeek!
        case .monthly:
            dueDate = startDate.endOfMonth
        }
        
        challenge.id = String(Int.random(in: 100000..<999999))
        challenge.title = title
        challenge.description = description
        challenge.count = count
        challenge.toDos = toDos
        challenge.startDate = startDate
        challenge.endDate = endDate
        challenge.dueDate = dueDate
        
        ChallengesRepository.createChallenge(challenge)
        challenge = Challenge()
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Ура", message: "Задача создана", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ок", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) -> Void in
            self.titleField.text = nil
            self.descriptionField.text = nil
            self.numberOfRepsField.text = nil
            
                                         }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

    //MARK: - PickerView

extension ChallengeCreationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch currentEditingMode {
            case .category:
                return ChallengeCategory.allCases.count
            case .duration:
                return ChallengeDuration.allCases.count
            case .difficulty:
                return ChallengeDifficulty.allCases.count
            case .fee:
                return ChallengeFee.allCases.count
            case .type:
                return ChallengeType.allCases.count
            default:
                return 0
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Helvetica Neue", size: 22)
        
        label.textAlignment = .center
        switch currentEditingMode {
        case .category:
            label.text = ChallengeCategory(rawValue: row)?.string()
        case .duration:
            label.text = ChallengeDuration(rawValue: row)?.string()
        case .difficulty:
            label.text = ChallengeDifficulty(rawValue: row)?.string()
        case .fee:
            label.text =  ChallengeFee(rawValue: row)?.string()
        case .type:
            label.text =  ChallengeType(rawValue: row)?.string()
        default:
            label.text = ""
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}

extension ChallengeCreationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateToDoCell.identifier) as! CreateToDoCell
        let task = toDos[indexPath.row]
        cell.deleteButton.addTarget(self, action: #selector(removeCell(_:)), for: .touchUpInside)
        cell.numberLabel.text = "\(indexPath.row+1)"
        cell.textField.addTarget(self, action: #selector(saveTask(_:)), for: .editingDidEnd)
        if task != "" {
            cell.textField.text = task
        } else {
            cell.textField.text = nil
        }
        return cell
    }
    
    @objc func saveTask(_ sender: UITextField) {
        let hitPoint = sender.convert(CGPoint.zero, to: toDosTableView)
        if let index = toDosTableView.indexPathForRow(at: hitPoint)?.row, let text = sender.text {
            toDos[index] = text
        }
    }
    
    @objc func removeCell(_ sender: UIButton) {
        let hitPoint = sender.convert(CGPoint.zero, to: toDosTableView)
        if let indexPath = toDosTableView.indexPathForRow(at: hitPoint) {
            
            self.toDos.remove(at: indexPath.row)
            self.toDosTableView.reloadData()
            
        }
        additionalInfoViewIsVisibleConstraint.constant = self.toDosTableView.contentSize.height + 35
    }

}
