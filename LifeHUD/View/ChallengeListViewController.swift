//
//  ViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 16.08.2022.
//

import UIKit

class ChallengesListViewController: UIViewController {
    
    // Main view model
    var challengesListViewModel: ChallengesListViewModelProtocol
    
    
    // Initializers for DI container
    init?(coder: NSCoder, challengesListViewModel: ChallengesListViewModelProtocol) {
        self.challengesListViewModel = challengesListViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChallengesManager is missing")
    }
    
    
    // String literals for section headers
    let dailyTasksSectionHeader = "Ежедневные задания"
    let weeklyTasksSectionHeader = "Задания на неделю"
    let monthlyTasksSectionHeader = "Задания на месяц"
    let numberOfSections = 3
    
    
    // Table view and it's refresh control
    @IBOutlet weak var challengesTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    

    // Initial setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table view
        setupChallengesTableView()
        
        // Load challenges for table view
        challengesListViewModel.fetchSortedChallenges(completion: { [weak self] in
            self?.challengesTableView.reloadData()
        })
        
    }
    
    // MARK: - private functions
    
    private func setupChallengesTableView() {
        
        // Register cell
        let bundle = Bundle.main
        let challengeCellNib = UINib(nibName: "ChallengeCell", bundle: bundle)
        challengesTableView.register(challengeCellNib, forCellReuseIdentifier: ChallengeCell.identifier)
        
        // DataSource and Delegate
        challengesTableView.dataSource = self
        challengesTableView.delegate = self
        
        // Refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Обновить")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        challengesTableView.addSubview(refreshControl)
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        // Loading challenges
        challengesListViewModel.fetchSortedChallenges(completion: { [weak self] in
            self?.challengesTableView.reloadData()
        })
        
        refreshControl.endRefreshing()
    }

}

extension ChallengesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Gets full info vc for specific challenges and presents it
        challengesListViewModel.userSelectedChallenge(at: indexPath, completion: { [weak self] vc in
            self?.present(vc, animated: true)
        })
    }

}

extension ChallengesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections // Constant
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of challenges in section provided by view model
        challengesListViewModel.getChallengesCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Base cell
        let cell = tableView.dequeueReusableCell(withIdentifier: ChallengeCell.identifier) as! ChallengeCell
        
        // Get view model for specific challenge
        let viewModel: ChallengeCellDisplayProtocol = challengesListViewModel.getChallengeCellVM(for: indexPath)
        
        // Fills the cell with challenge info
        cell.fill(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Constants
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
