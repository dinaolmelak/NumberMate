//
//  PlayViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/25/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PlayViewController: UIViewController, GADRewardedAdDelegate {
    
    

    @IBOutlet weak var simpleBannerAd: GADBannerView!
    var rewardedAd: GADRewardedAd?
    var ad = MobAds()
    var show = Function()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ad.bannerDisplay(simpleBannerAd, self)
        self.rewardedAd = ad.createAndLoadRewardedAd()
    }
    
    @IBAction func onPlay(_ sender: Any) {
        performSegue(withIdentifier: "GameSegue", sender: self)
    }
    
    @IBAction func onWatchAd(_ sender: Any) {
        //show.showQuestion(Title: , Message: ,ViewController: self)
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
