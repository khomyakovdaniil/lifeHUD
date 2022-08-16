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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
