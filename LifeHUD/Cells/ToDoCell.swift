//
//  toDoCell.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    
    static let identifier = String(describing: ToDoCell.self)
    
    
    weak var delegate: ToDoCellDelegate!
    var indexPath: IndexPath? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    
    @IBAction func checkboxTapped(_ sender: Any) {
        checkBox.isSelected = !checkBox.isSelected
        guard let indexPath = indexPath else {
            return
        }
        if checkBox.isSelected {
            delegate.checkBoxSelected(at: indexPath)
        } else {
            delegate.checkBoxUnselected(at: indexPath)
        }
    }
    
}

protocol ToDoCellDelegate: class {
    func checkBoxSelected(at: IndexPath)
    func checkBoxUnselected(at: IndexPath)
}
