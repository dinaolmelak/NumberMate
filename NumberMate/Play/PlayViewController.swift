//
//  PlayViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/25/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import GoogleMobileAds

class PlayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, GADRewardedAdDelegate {
    
    @IBOutlet weak var simpleBannerAd: GADBannerView!
    
    @IBOutlet weak var playTableView: UITableView!
    var rewardedAd: GADRewardedAd?
    var ad = MobAds()
    var show = Function()
    var firy: Fire!
    var db: Firestore!
    var rewardPoints = NumberPoints()
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        firy = Fire()
        // Do any additional setup after loading the view.
        ad.bannerDisplay(simpleBannerAd, self)
        self.rewardedAd = ad.createAndLoadRewardedAd()
        playTableView.dataSource = self
        playTableView.delegate = self
        playTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            let cell = playTableView.dequeueReusableCell(withIdentifier: "PlayTitleCell") as! PlayTitleCell
            
            return cell
        }
        else if(indexPath.row == 1){
            let cell = playTableView.dequeueReusableCell(withIdentifier: "PlayCell") as! PlayCell
            return cell
        }else if(indexPath.row == 2){
            let cell = playTableView.dequeueReusableCell(withIdentifier: "GetPointCell") as! GetPointCell
            cell.getPointsButton.addTarget(self, action: #selector(onWatchAd), for: .touchUpInside)
            return cell
        }else {
            let cell = playTableView.dequeueReusableCell(withIdentifier: "InviteFriendCell") as! InviteFriendCell
            return cell
        }
    }
    func animateUp(Button botton: UIButton){
        UIView.animate(withDuration: 1) {
            botton.center.y -= CGFloat(50.0)
        }
    }

    func animateDown(Button botton:UIButton){
        UIView.animate(withDuration: 1) {
            botton.center.y += CGFloat(50.0)
        }

    }
    
    
    
    @objc func onWatchAd() {
        guard self.rewardedAd?.isReady == true else{
            return
        }
        let alert = UIAlertController(title: "More Points!", message: "Watch a short Ad to get \(rewardPoints.adVidRewardPoint) points?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "YES", style: .default) { (UIAlertAction) in
            if self.rewardedAd?.isReady == true{
                self.rewardedAd?.present(fromRootViewController: self, delegate: self)
                
            }
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
                present(alert, animated: true)

    }
    
    
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        print("___\(reward.amount.doubleValue)")
        firy.increamentPoints(by: reward.amount.intValue) { (error) in
            if let error = error{
                print(error as Any)
            }else{
                print("Success increament \(reward.amount.intValue)")
            }
        }
        if rewardedAd.responseInfo != nil{
          show.showAlert(Title: "Earned", Message: "You have earned \(reward.amount.intValue )", ViewController: self)
        }
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.rewardedAd = ad.createAndLoadRewardedAd()
        
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
