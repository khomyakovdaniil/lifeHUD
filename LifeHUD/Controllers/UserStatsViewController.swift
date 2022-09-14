//
//  UserStatsViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 18.08.2022.
//

import UIKit

class UserStatsViewController: UIViewController {
    
    
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthLabel.text = String(UserStats.getHealthXP())
        workLabel.text = String(UserStats.getWorkXP())
        disciplineLabel.text = String(UserStats.getDisciplineXP())
        homeLabel.text = String(UserStats.getHomeXP())
        setupHistoryTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        healthLabel.text = String(UserStats.getHealthXP())
        workLabel.text = String(UserStats.getWorkXP())
        disciplineLabel.text = String(UserStats.getDisciplineXP())
        homeLabel.text = String(UserStats.getHomeXP())
    }
    
    private func setupHistoryTableView() {
        let bundle = Bundle.main
        let historyCellNib = UINib(nibName: "HistoryCell", bundle: bundle)
        historyTableView.register(historyCellNib, forCellReuseIdentifier: HistoryCell.identifier)
        historyTableView.dataSource = self
        historyTableView.delegate = self
    }
    
}

extension UserStatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserHistory.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier) as! HistoryCell
        let entry = UserHistory.history[indexPath.row]
        cell.fill(with: entry) // Fills the cell with challenge info
        return cell
    }
    
    
}
