//
//  ViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit

class ChallengeListViewController: UIViewController {
    
    @IBOutlet weak var challengesTableView: UITableView!
    
    let challengesDataSource = ChallengesDataSource.shared
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        ChallengesRepository.shared.loadChallenges() {_ in
            self.challengesDataSource.delegate = self
            self.setupChallengesTableView()
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
        ChallengesRepository.shared.loadChallenges() { _ in
            self.challengesTableView.reloadData()
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
        var challenge = Challenge()
        switch indexPath.section {
        case 0:
            challenge = challengesDataSource.dailyChallenges[indexPath.row]
        case 1:
            challenge = challengesDataSource.weeklyChallenges[indexPath.row]
        case 2:
            challenge = challengesDataSource.monthlyChallenges[indexPath.row]
        default:
            break
        }
        let challengeFullInfoVC = ChallengeFullInfoViewController(challenge: challenge, dataSource: challengesDataSource)
        challengeFullInfoVC.modalPresentationStyle = .fullScreen
        self.present(challengeFullInfoVC, animated: false)
    }

}

extension ChallengeListViewController: DataSourceDelegateProtocol {
    func challengeListUpdated() {
        challengesTableView.reloadData()
    }
}

extension ChallengeListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return challengesDataSource.dailyChallenges.count
        case 1:
            return challengesDataSource.weeklyChallenges.count
        case 2:
            return challengesDataSource.monthlyChallenges.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeCell.identifier) as! ChallengeCell
        let challenge = challenge(for: indexPath)
        let viewModel = ChallengeCellViewModel(challenge: challenge)
        cell.fill(with: viewModel) // Fills the cell with challenge info
        return cell
    }
    
    private func challenge(for indexPath: IndexPath) -> Challenge {
        let index = indexPath.row
        switch indexPath.section {
        case 0:
            return challengesDataSource.dailyChallenges[index]
        case 1:
            return challengesDataSource.weeklyChallenges[index]
        case 2:
            return challengesDataSource.monthlyChallenges[index]
        default:
            return Challenge()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return challengesDataSource.dailyTasksSectionHeader
        case 1:
            return challengesDataSource.weeklyTasksSectionHeader
        case 2:
            return challengesDataSource.monthlyTasksSectionHeader
        default:
            return ""
        }
    }

}
