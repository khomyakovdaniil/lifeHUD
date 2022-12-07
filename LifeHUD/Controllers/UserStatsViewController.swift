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
    
    private let refreshControl = UIRefreshControl()
    
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
        refreshControl.attributedTitle = NSAttributedString(string: "Обновить")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        historyTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        UserHistory.loadHistory()
        historyTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

extension UserStatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return UserHistory.sortedHistoryDictionary.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = UserHistory.sortedHistoryDictionary[section]
        var formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let title = formatter.string(from: day.key)
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = UserHistory.sortedHistoryDictionary[section].value
        return day.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier) as! HistoryCell
        let day = UserHistory.sortedHistoryDictionary[indexPath.section].value
        let entry = day[indexPath.row]
        cell.fill(with: entry) // Fills the cell with challenge info
        return cell
    }
    
    
}
