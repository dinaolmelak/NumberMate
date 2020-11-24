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
    var firy: Fire!
    var funcs = Function()
    var earnedMoney = [Earned]()
//    var carAnimationView: AnimationView?
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var simpleBannerAd: GADBannerView!
    @IBOutlet weak var moneyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        firy = Fire()
        //carAnimation = .init(name: "1204-car")
        //carAnimation.loopMode = .loop
        
        ad.bannerDisplay(simpleBannerAd, self)
        moneyTableView.delegate = self
        moneyTableView.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        playCarAnimation()
        funcs.startActivityIndicator(activityIndicator, ViewController: self)
                playerDataFromdb()
            firy.listenEarnedPayments() { (earned) in
                self.earnedMoney = earned
                self.moneyTableView.reloadData()
            }
        funcs.stopActivityIndicator(activityIndicator, ViewController: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earnedMoney.count + 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = moneyTableView.dequeueReusableCell(withIdentifier: "ProfileTitleCell", for: indexPath) as! ProfileTitleCell
            
            
            return cell
        }else if(indexPath.row == 1){
            
            let cell = moneyTableView.dequeueReusableCell(withIdentifier: "PlayerInfoCell", for: indexPath) as! PlayerInfoCell
            
            self.firy.listenPlayerInfo() { (playerInfo) in
                cell.fullNameLabel.text =
                 playerInfo.fname + " " + playerInfo.lname
                cell.emailLabel.text = playerInfo.email
                cell.npointsLabel.text = String(playerInfo.points)
                cell.gameCount.text =  String(playerInfo.game_count)
                cell.winCount.text =  String(playerInfo.won_game_count)
            
                }
            return cell
        }
        else{
            if earnedMoney.count == 0{
                let cell = moneyTableView.dequeueReusableCell(withIdentifier: "MoneyCell", for: indexPath) as! MoneyCell
                cell.amountLabel.alpha = 0
                cell.dateLabel.alpha = 0
                cell.displayLabel.text = "Rewards will appear here"
                cell.displayLabel.alpha = 1.0
                return cell
            }else{
                let cell = moneyTableView.dequeueReusableCell(withIdentifier: "MoneyCell", for: indexPath) as! MoneyCell
                let element = earnedMoney[indexPath.row - 2]
                cell.displayLabel.alpha = 0.0
                cell.dateLabel.text = String(element.points)
                cell.amountLabel.text = String(element.amountEarned)
                return cell
            }
        }
    }
    
    
    func playerDataFromdb(){
        firy.listenPlayerInfo() { (playerInfo) in
            print("playerInfo___\(playerInfo)")
            self.setDataToLabel(FName: playerInfo.fname, LName: playerInfo.lname, email: playerInfo.email, Points: playerInfo.points, GameCount: playerInfo.game_count,WinCount: playerInfo.won_game_count,
                                TimeTaken: playerInfo.min_time_taken)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
//        stopPlayingAnimation()
//        firy.detachListener()
    }
//    func stopPlayingAnimation(){
//        carAnimationView?.stop()
//        view.subviews.last?.removeFromSuperview()
//    }
//    func playCarAnimation(){
//        carAnimationView = .init(name: "1204-car")
//
//        carAnimationView!.contentMode = .scaleAspectFit
//        /// Converts a rect
//        //carAnimationView!.bounds.width = view.bounds.width
//        //carAnimationView!.bounds.height = view.bounds.height
//        carAnimationView!.frame = CGRect(x: view.frame.width / 4, y: 0, width: 250, height: 200)
//        view.addSubview(carAnimationView!)
//        carAnimationView!.loopMode = .loop
//        carAnimationView!.animationSpeed = 2
//        carAnimationView!.play()
//    }
    
    func setDataToLabel(FName fName: String, LName lName: String, email inEmail: String,Points inPoint: Int, GameCount inGame: Int,WinCount winnings:Int, TimeTaken timeTaken: Int){
        
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
