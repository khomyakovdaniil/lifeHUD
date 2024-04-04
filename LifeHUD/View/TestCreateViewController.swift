//
//  TestCreateViewController.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 23.03.2024.
//

import UIKit

class TestCreateViewController: UIViewController {
    
    @IBOutlet weak var difficultyTableView: UITableView!
    
    var vM: TestCreateViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        difficultyTableView.delegate = self
        difficultyTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestCreateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vM?.getDifficultyCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = vM?.getTextForIndex(for: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vM?.selectedDifficultyItem(with: indexPath.row)
    }
}
