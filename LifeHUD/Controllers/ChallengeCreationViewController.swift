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
              let type = ChallengeType(rawValue: typePicker.selectedRow(inComponent: 0)) else { return }
            
        challenge.category = category
        challenge.duration = duration
        challenge.difficulty = difficulty
        challenge.failFee =  failFee
        challenge.type = type
        challenge.id = String(Int.random(in: 100000..<999999))
        
        ChallengesRepository.createChallenge(challenge)
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
    

}
