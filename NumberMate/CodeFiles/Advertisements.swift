//
//  Advertisements.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/25/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import Foundation
import GoogleMobileAds

class MobAds{
    let adUnitID = "ca-app-pub-3940256099942544/2934735716"
    let rewardAdID = "ca-app-pub-3940256099942544/1712485313"

    func bannerDisplay(_ bannerView: GADBannerView,_ vc: UIViewController){
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = vc
        bannerView.load(GADRequest())
    }
    func createAndLoadRewardedAd()-> GADRewardedAd? {
        var grewardedAd: GADRewardedAd?
        grewardedAd = GADRewardedAd(adUnitID: rewardAdID)
      grewardedAd?.load(GADRequest()) { error in
        if let error = error {
          print("Loading failed: \(error)")
        } else {
          print("Loading Succeeded")
        }
      }
      return grewardedAd
    }
    
    
}
