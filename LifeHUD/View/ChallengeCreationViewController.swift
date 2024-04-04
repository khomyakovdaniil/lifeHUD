//
//  ChallengeCreationViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 17.08.2022.
//

import UIKit

class ChallengeCreationViewController: UIViewController {
    
    init?(coder: NSCoder, viewModel: ChallengeCreationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChallengesManager is missing")
    }
    
    var viewModel: ChallengeCreationViewModelProtocol
    
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
    
    /// constants and variables for pickerView alerts
    private let screenWidth = UIScreen.main.bounds.width - 10
    private let screenHeight = UIScreen.main.bounds.height / 1
    private var selectedRow = 0
    
    /// switcher for presenting pickerView alerts
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
    
    private let toDosTableViewRowHeight = 44.0
    private let additionalInfoViewHeightForCounter = 44.0
    private let heightNeededForAddCellButton = 40.0
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupKeyboardDissmisal()
    }
    
    // MARK: - UI
    
    private func setupViews() {
        setupPickerButtons()
        setupAdditionalInfoView(for: .singleAction)
        setupTitleAndDescriptionFields()
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
    
    private func setupAdditionalInfoView(for type: ChallengeType) { // TODO: dependency
        switch type {
        case .singleAction:
            hideAdditionalInfoView()
        case .counter:
            showAdditionalInfoViewWithCounter()
        case .checkbox:
            showAdditionalInfoViewWithToDos()
        }
    }
    
    private func setupTitleAndDescriptionFields() {
        titleField.delegate = self
        descriptionField.delegate = self
    }
    
    private func hideAdditionalInfoView() {
        additionalInfoView.isHidden = true
        additionalInfoViewIsVisibleConstraint.isActive = false
        additionalInfoViewIsHiddenConstraint.isActive = true
    }
    
    private func showAdditionalInfoViewWithCounter() {
        additionalInfoView.isHidden = false
        additionalInfoViewIsHiddenConstraint.isActive = false
        additionalInfoViewIsVisibleConstraint.constant = additionalInfoViewHeightForCounter
        additionalInfoViewIsVisibleConstraint.isActive = true
        toDosView.isHidden = true
        counterView.isHidden = false
    }
    
    private func showAdditionalInfoViewWithToDos() {
        additionalInfoView.isHidden = false
        additionalInfoViewIsHiddenConstraint.isActive = false
        additionalInfoViewIsVisibleConstraint.constant = self.toDosTableView.contentSize.height + heightNeededForAddCellButton
        additionalInfoViewIsVisibleConstraint.isActive = true
        counterView.isHidden = true
        toDosView.isHidden = false
    }
    
    private func setupCategoryPickerButton() {
        categoryPickerButton.setTitle("Категория", for: .normal)
    }
    
    private func setupDurationPickerButton() {
        durationPickerButton.setTitle("Длительность", for: .normal)
    }
    
    private func setupDifficultyPickerButton() {
        difficultyPickerButton.setTitle("Сложность", for: .normal)
    }
    
    private func setupFailFeePickerButton() {
        failFeePickerButton.setTitle("Штраф", for: .normal)
    }
    
    private func setupTypePickerButton() {
        typePickerButton.setTitle("Тип", for: .normal)
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
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: setting.pickerName(), message: "", preferredStyle: .actionSheet)
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Выбрать", style: .default, handler: { [weak self] (UIAlertAction) in
            guard let self else { return }
            switch self.currentEditingMode {
            case .category:
                self.viewModel.selectedItem(with: pickerView.selectedRow(inComponent: 0), of: .category())
                let title = viewModel.getText(for: pickerView.selectedRow(inComponent: 0), of: .category())
                categoryPickerButton.setTitle(title, for: .normal)
            case .duration:
                self.viewModel.selectedItem(with: pickerView.selectedRow(inComponent: 0), of: .duration())
                let title = viewModel.getText(for: pickerView.selectedRow(inComponent: 0), of: .duration())
                durationPickerButton.setTitle(title, for: .normal)
            case .fee:
                self.viewModel.selectedItem(with: pickerView.selectedRow(inComponent: 0), of: .failFee())
                let title = viewModel.getText(for: pickerView.selectedRow(inComponent: 0), of: .failFee())
                failFeePickerButton.setTitle(title, for: .normal)
            case .difficulty:
                self.viewModel.selectedItem(with: pickerView.selectedRow(inComponent: 0), of: .difficulty())
                let title = viewModel.getText(for: pickerView.selectedRow(inComponent: 0), of: .difficulty())
                difficultyPickerButton.setTitle(title, for: .normal)
            case .type:
                self.viewModel.selectedItem(with: pickerView.selectedRow(inComponent: 0), of: .type())
                let title = viewModel.getText(for: pickerView.selectedRow(inComponent: 0), of: .type())
                typePickerButton.setTitle(title, for: .normal)
                let type = ChallengeType(rawValue: pickerView.selectedRow(inComponent: 0))! // TODO: dependency
                setupAdditionalInfoView(for: type)
            case nil:
                return
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addToDoButtonTapped(_ sender: Any) {
        toDos.append("")
        toDosTableView.insertRows(at: [IndexPath(row: toDos.count-1, section: 0)], with: .none)
        additionalInfoViewIsVisibleConstraint.constant = self.toDosTableView.contentSize.height + heightNeededForAddCellButton
    }
    
    @IBAction func createButtonTapped(_ sender: Any) { // TODO: - move logic to view model
        viewModel.userEntered(date: startDatePicker.date, for: .startDate())
        viewModel.userEntered(date: endDatePicker.date, for: .endDate())
        viewModel.userTappedCreateButton()
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

    // MARK: - PickerViews

extension ChallengeCreationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch currentEditingMode {
            case .category:
                return viewModel.getCount(for: .category())
            case .duration:
                return viewModel.getCount(for: .duration())
            case .difficulty:
                return viewModel.getCount(for: .difficulty())
            case .fee:
                return viewModel.getCount(for: .failFee())
            case .type:
                return viewModel.getCount(for: .type())
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
            label.text = viewModel.getText(for: row, of: .category())
        case .duration:
            label.text = viewModel.getText(for: row, of: .duration())
        case .difficulty:
            label.text = viewModel.getText(for: row, of: .difficulty())
        case .fee:
            label.text =  viewModel.getText(for: row, of: .failFee())
        case .type:
            label.text =  viewModel.getText(for: row, of: .type())
        default:
            label.text = ""
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return toDosTableViewRowHeight
    }
}
    
    // MARK: - Subtasks tableView

extension ChallengeCreationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateToDoCell.identifier) as! CreateToDoCell
        
        /// adds removeCell action to delete button
        cell.deleteButton.addTarget(self, action: #selector(removeCell(_:)), for: .touchUpInside)
        
        /// sets number label according to current position
        cell.numberLabel.text = "\(indexPath.row+1)"
        
        /// adds action to textField, data saves when editing finishes
        cell.textField.addTarget(self, action: #selector(saveTask(_:)), for: .editingDidEnd)
        
        /// check related data entry
        let task = toDos[indexPath.row]
       
        if task != "" {
            /// fill with non empty data entry
            cell.textField.text = task
        } else {
            /// clear cell for empty data entry
            cell.textField.text = nil
        }
        return cell
    }
    
    @objc func saveTask(_ sender: UITextField) {
        let hitPoint = sender.convert(CGPoint.zero, to: toDosTableView) /// position from sender
        if let indexPath = toDosTableView.indexPathForRow(at: hitPoint), let text = sender.text {
            /// indexPath for position, text from sender UITextField
            toDos[indexPath.row] = text /// saves text to data entry
        }
    }
    
    @objc func removeCell(_ sender: UIButton) {
        let hitPoint = sender.convert(CGPoint.zero, to: toDosTableView) /// postion from sender
        if let indexPath = toDosTableView.indexPathForRow(at: hitPoint) { /// indexPath for position
            self.toDos.remove(at: indexPath.row) /// removes data entry
            self.toDosTableView.reloadData() /// removes cell
        }
        additionalInfoViewIsVisibleConstraint.constant = self.toDosTableView.contentSize.height + heightNeededForAddCellButton /// resizes additionalInfoView to fit toDosTableView
    }

}

extension ChallengeCreationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleField {
            viewModel.userEntered(text: textField.text ?? "", for: .title())
        } else {
            viewModel.userEntered(text: textField.text ?? "", for: .description())
        }
    }
}
