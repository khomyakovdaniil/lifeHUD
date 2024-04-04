//
//  UserStatsViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 18.08.2022.
//

import UIKit

protocol UserStatsDisplay {
    
}

class UserStatsViewController: UIViewController {
    
    init?(coder: NSCoder, challengesManager: ChallengesManagingProtocol) {
        self.challengesManager = challengesManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var challengesManager: ChallengesManagingProtocol
    
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHistoryTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let healthXP = defaults.value(forKey: ChallengeCategory.health.xpStorageKey()) as? Int ?? 0
        healthLabel.text = String(healthXP)
        let workXP = defaults.value(forKey: ChallengeCategory.work.xpStorageKey()) as? Int ?? 0
        workLabel.text = String(workXP)
        let disciplineXP = defaults.value(forKey: ChallengeCategory.discipline.xpStorageKey()) as? Int ?? 0
        disciplineLabel.text = String(disciplineXP)
        let homeXP = defaults.value(forKey: ChallengeCategory.home.xpStorageKey()) as? Int ?? 0
        homeLabel.text = String(homeXP)
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
        NetworkManager.fetchRemoteHistory()
        historyTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

extension UserStatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return challengesManager.userStatsManager.sortedHistoryDictionary.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = challengesManager.userStatsManager.sortedHistoryDictionary[section]
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let title = formatter.string(from: day.key)
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = challengesManager.userStatsManager.sortedHistoryDictionary[section].value
        return day.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier) as! HistoryCell
        let day = challengesManager.userStatsManager.sortedHistoryDictionary[indexPath.section].value
        guard indexPath.row < day.count else { return cell }
        let entry = day[indexPath.row]
        cell.fill(with: entry) // Fills the cell with challenge info
        return cell
    }
    
    
}
