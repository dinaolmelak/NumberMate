//
//  ProfilePicViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/15/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class ProfilePicViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var minimumTimeLabel: UILabel!
    @IBOutlet weak var gameCount: UILabel!
    @IBOutlet weak var npointsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = gamesTableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as UITableViewCell
        let cell = UITableViewCell()
        
        return cell
    }
    @IBAction func didTapSetting(_ sender: Any) {
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
