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
        ChallengesRepository.loadChallenges()
        challengesDataSource.delegate = self
        setupChallengesTableView()
    }
    
    // MARK: - private
    
    private func setupChallengesTableView() {
        let bundle = Bundle.main
        let challengeCellNib = UINib(nibName: "ChallengeCell", bundle: bundle)
        challengesTableView.register(challengeCellNib, forCellReuseIdentifier: ChallengeCell.identifier)
        challengesTableView.dataSource = challengesDataSource
        challengesTableView.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Обновить")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        challengesTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        ChallengesRepository.loadChallenges()
        challengesTableView.reloadData()
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
