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

class PlayViewController: UIViewController, GADRewardedAdDelegate {
    
    

    @IBOutlet weak var simpleBannerAd: GADBannerView!
    @IBOutlet weak var playButton: UIButton!
    var rewardedAd: GADRewardedAd?
    var ad = MobAds()
    var show = Function()
    var fire = Fire()
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
        playButton.layer.cornerRadius = 20
        ad.bannerDisplay(simpleBannerAd, self)
        self.rewardedAd = ad.createAndLoadRewardedAd()
    }
    
    @IBAction func onPlay(_ sender: Any) {
        performSegue(withIdentifier: "GameSegue", sender: self)
    }
    
    @IBAction func onWatchAd(_ sender: Any) {
        //show.showQuestion(Title: , Message: ,ViewController: self)
        guard self.rewardedAd?.isReady == true else{
            return
        }
        let alert = UIAlertController(title: "More Points!", message: "Watch a short Ad to get 20 points?", preferredStyle: .alert)
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
        fire.increamentPoints(Firebase: db, by: reward.amount.intValue) { (error) in
            if let error = error{
                print(error as Any)
            }else{
                print("Success increament \(reward.amount.intValue)")
            }
        }
        if rewardedAd.responseInfo != nil{
          show.showAlert(Title: "Earned", Message: "You have earned \(reward.amount.intValue * 2)", ViewController: self)
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
