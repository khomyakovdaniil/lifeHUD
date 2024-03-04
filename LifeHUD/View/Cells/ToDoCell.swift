//
//  toDoCell.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    
    static let identifier = String(describing: ToDoCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    
    @IBAction func checkboxTapped(_ sender: Any) {
        checkBox.isSelected = !checkBox.isSelected
    }
    
}
