//
//  ViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit

protocol ChallengeListViewControllerProtocol: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var sortedChallengesProvider: SortedChallengesProviderProtocol { get }
}

class ChallengeListViewController: UIViewController, ChallengeListViewControllerProtocol {
    
    let dailyTasksSectionHeader = "Ежедневные задания"
    let weeklyTasksSectionHeader = "Задания на неделю"
    let monthlyTasksSectionHeader = "Задания на месяц"
    
    var sortedChallengesProvider: SortedChallengesProviderProtocol = ChallengesManager.shared
    
    @IBOutlet weak var challengesTableView: UITableView!
    
    var challenges: [[Challenge]]?
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        sortedChallengesProvider.fetchSortedChallenges() { [weak self] _ in
            self?.challenges = [ChallengesManager.shared.dailyChallenges,
                                ChallengesManager.shared.weeklyChallenges,
                                ChallengesManager.shared.monthlyChallenges]
            self?.setupChallengesTableView()
        }
    }
    
    // MARK: - private
    
    private func setupChallengesTableView() {
        let bundle = Bundle.main
        let challengeCellNib = UINib(nibName: "ChallengeCell", bundle: bundle)
        challengesTableView.register(challengeCellNib, forCellReuseIdentifier: ChallengeCell.identifier)
        challengesTableView.dataSource = self
        challengesTableView.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Обновить")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        challengesTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        var challenges = sortedChallengesProvider.fetchSortedChallenges() { [weak self] _ in
            self?.setupChallengesTableView()
        }
        refreshControl.endRefreshing()
    }

}

extension ChallengeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let challenges = challenges,
              indexPath.section < challenges.count,
              indexPath.row < challenges[indexPath.section].count else {
            return
        }
        let challenge = challenges[indexPath.section][indexPath.row]
        let challengeFullInfoVC = ChallengeFullInfoViewController(challenge: challenge)
        challengeFullInfoVC.modalPresentationStyle = .fullScreen
        self.present(challengeFullInfoVC, animated: false)
    }

}

extension ChallengeListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return challenges?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeCell.identifier) as! ChallengeCell
        guard let challenge = challenges?[indexPath.section][indexPath.row] else {
            return cell
        }
        let viewModel = ChallengeCellViewModel(challenge: challenge)
        cell.fill(with: viewModel) // Fills the cell with challenge info
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return dailyTasksSectionHeader
        case 1:
            return weeklyTasksSectionHeader
        case 2:
            return monthlyTasksSectionHeader
        default:
            return ""
        }
    }

}
