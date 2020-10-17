//
//  ProfilePicViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/15/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import Lottie
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds


class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var ad = MobAds()
    var db: Firestore!
    let fire = Fire()
    var earnedMoney = [Earned]()
    var carAnimationView: AnimationView?
    @IBOutlet weak var simpleBannerAd: GADBannerView!
    @IBOutlet weak var moneyTableView: UITableView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var minimumTimeLabel: UILabel!
    @IBOutlet weak var gameCount: UILabel!
    @IBOutlet weak var npointsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var totalEarning: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        //carAnimation = .init(name: "1204-car")
        //carAnimation.loopMode = .loop
        
        ad.bannerDisplay(simpleBannerAd, self)
        moneyTableView.delegate = self
        moneyTableView.dataSource = self
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        playCarAnimation()
        fire.listenEarnedPayments(Firestore: db) { (earned) in
            self.earnedMoney = earned
            self.moneyTableView.reloadData()
            if self.earnedMoney.isEmpty == true || self.earnedMoney.count == 0{
                let emptyLabel = UILabel()
                var myView = UIView()
                let pic = UIImage(named: "iTunesArtwork")!
                emptyLabel.text = "Sorry, No Money Earned"
                emptyLabel.textAlignment = .center
                let picture = UIImageView(image: pic)
                //myView = picture
                myView = emptyLabel
                self.moneyTableView.backgroundView = myView
                self.moneyTableView.reloadData()
                //moneyTableView.backgroundView!.addSubview(emptyLabel)
            }
            
        }
        
        playerDataFromdb()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earnedMoney.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moneyTableView.dequeueReusableCell(withIdentifier: "MoneyCell", for: indexPath) as! MoneyCell
        let element = earnedMoney[indexPath.row]
        
        cell.dateLabel.text = String(element.batchid)
        cell.amountLabel.text = String(element.amountEarned)
        return cell
    }
    @IBAction func didTapSetting(_ sender: Any) {
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    func playerDataFromdb(){
        fire.listenPlayerInfo(Firestore: db) { (playerInfo) in
            self.setDataToLabel(FName: playerInfo.fname, LName: playerInfo.lname, email: playerInfo.email, Points: playerInfo.points, GameCount: playerInfo.game_count, TimeTaken: playerInfo.min_time_taken)
        }
    }
    
    func playCarAnimation(){
        carAnimationView = .init(name: "1204-car")
        
        carAnimationView!.contentMode = .scaleAspectFit
        /// Converts a rect
        //carAnimationView!.bounds.width = view.bounds.width
        //carAnimationView!.bounds.height = view.bounds.height
        carAnimationView!.frame = CGRect(x: view.frame.width / 4, y: 0, width: 250, height: 200)
        view.addSubview(carAnimationView!)
        carAnimationView!.loopMode = .loop
        carAnimationView!.animationSpeed = 2
        carAnimationView!.play()
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
