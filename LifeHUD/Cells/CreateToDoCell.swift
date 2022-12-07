//
//  CreateToDoTableViewCell.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 06.12.2022.
//

import UIKit

class CreateToDoCell: UITableViewCell {
    
    static let identifier = String(describing: CreateToDoCell.self)
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
