//
//  ProfilePicViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/15/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds


class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var ad = MobAds()
    var db: Firestore!
    let fire = Fire()
    @IBOutlet weak var simpleBannerAd: GADBannerView!
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
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        ad.bannerDisplay(simpleBannerAd, self)
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        getDataFromdb()
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
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    func getDataFromdb(){
        fire.listenPlayerInfo(Firestore: db) { (playerInfo) in
            self.setDataToLabel(FName: playerInfo.fname, LName: playerInfo.lname, email: playerInfo.email, Points: playerInfo.points, GameCount: playerInfo.game_count, TimeTaken: playerInfo.min_time_taken)
        }
    }
    
    func setDataToLabel(FName fName: String, LName lName: String, email inEmail: String,Points inPoint: Int, GameCount inGame: Int, TimeTaken timeTaken: Int){
        fullNameLabel.text = fName + " " + lName
        emailLabel.text = inEmail
        npointsLabel.text = String(inPoint)
        minimumTimeLabel.text = String(timeTaken)
        gameCount.text = String(inGame)
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
