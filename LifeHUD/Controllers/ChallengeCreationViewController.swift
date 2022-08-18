//
//  ChallengeCreationViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 17.08.2022.
//

import UIKit

class ChallengeCreationViewController: UIViewController {
    
    var challenge = Challenge()
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var difficultyPicker: UIPickerView!
    @IBOutlet weak var failFeePicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var tasksField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerViews()
    }
    
    private func setupPickerViews() {
        setupCategoryPicker()
        setupDurationPicker()
        setupDifficultyPicker()
        setupFailFeePicker()
        setupTypePicker()
    }
    
    private func setupCategoryPicker() {
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
    }
    
    private func setupDurationPicker() {
        durationPicker.dataSource = self
        durationPicker.delegate = self
    }
    
    private func setupDifficultyPicker() {
        difficultyPicker.dataSource = self
        difficultyPicker.delegate = self
    }
    
    private func setupFailFeePicker() {
        failFeePicker.dataSource = self
        failFeePicker.delegate = self
    }
    
    private func setupTypePicker() {
        typePicker.dataSource = self
        typePicker.delegate = self
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard let category = ChallengeCategory(rawValue: categoryPicker.selectedRow(inComponent: 0)),
              let duration = ChallengeDuration(rawValue: durationPicker.selectedRow(inComponent: 0)),
              let difficulty = ChallengeDifficulty(rawValue: difficultyPicker.selectedRow(inComponent: 0)),
              let failFee = ChallengeFee(rawValue: failFeePicker.selectedRow(inComponent: 0)),
              let type = ChallengeType(rawValue: typePicker.selectedRow(inComponent: 0)),
              let title = titleField.text,
              title != "",
              let description = descriptionField.text,
              description != ""
        else { return }
        var count = 0
        var toDos: [String] = []
        if type == .counter {
            guard let number = tasksField.text else { return }
            count = Int(number) ?? 1
        } else if type == .checkbox {
            toDos = tasksField.text?.components(separatedBy: ",") ?? [""]
        }
        
        challenge.category = category
        challenge.duration = duration
        challenge.difficulty = difficulty
        challenge.failFee =  failFee
        challenge.type = type
        challenge.id = String(Int.random(in: 100000..<999999))
        challenge.title = title
        challenge.description = description
        challenge.count = count
        challenge.toDos = toDos
        
        ChallengesRepository.createChallenge(challenge)
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Ура", message: "Задача создана", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ок", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) -> Void in
            self.titleField.reloadInputViews()
            self.descriptionField.reloadInputViews()
            self.tasksField.reloadInputViews()
            
                                         }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ChallengeCreationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch pickerView {
            case categoryPicker:
                return ChallengeCategory.allCases.count
            case durationPicker:
                return ChallengeDuration.allCases.count
            case difficultyPicker:
                return ChallengeDifficulty.allCases.count
            case failFeePicker:
                return ChallengeFee.allCases.count
            case typePicker:
                return ChallengeType.allCases.count
            default:
                return 0
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Helvetica Neue", size: 10)
        label.textAlignment = .center
        switch pickerView {
        case categoryPicker:
            label.text = ChallengeCategory(rawValue: row)?.string()
        case durationPicker:
            label.text = ChallengeDuration(rawValue: row)?.string()
        case difficultyPicker:
            label.text = ChallengeDifficulty(rawValue: row)?.string()
        case failFeePicker:
            label.text =  ChallengeFee(rawValue: row)?.string()
        case typePicker:
            label.text =  ChallengeType(rawValue: row)?.string()
        default:
            label.text = ""
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typePicker {
            switch row {
            case 0:
                tasksField.isHidden = true
            case 1:
                self.tasksField.reloadInputViews()
                tasksField.placeholder = "Введите количество повторений"
                tasksField.keyboardType = .numberPad
                tasksField.isHidden = false
            case 2:
                self.tasksField.reloadInputViews()
                tasksField.placeholder = "Введите задачи через запятую"
                tasksField.keyboardType = .default
                tasksField.isHidden = false
            default:
                return
            }
        }
    }

}