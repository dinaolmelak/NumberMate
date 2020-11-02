//
//  AddFriend.swift
//  NumberMate
//
//  Created by Dinaol Melak on 10/14/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDynamicLinks

class AddFriendVC: UIViewController {
    let numbermateLink = "https://numbermate.page.link"
    let numbermateAppStoreID = "1227019728"
    let nmurlInvitePath = "/invites"
    let nmurlHost = "www.numbermate.com"
    let nmurlScheme = "https"
    let notify = Function()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapInvite(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }
        var components = URLComponents()
        components.scheme = nmurlScheme
        components.host = nmurlHost
        components.path = nmurlInvitePath
        let inviteIdQuery = URLQueryItem(name: "invitedby", value: user.uid)
        components.queryItems = [inviteIdQuery]
        
        guard let linkPara = components.url else {
            return
        }//link works
        print("DDDD\(linkPara)")
        guard let sharelink = DynamicLinkComponents.init(link: linkPara, domainURIPrefix: numbermateLink) else{
            print("coundn't create firebase DL component")
            return
        }
        if let myBundleID = Bundle.main.bundleIdentifier{
            sharelink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleID)
        }
        sharelink.iOSParameters?.appStoreID = numbermateAppStoreID
        sharelink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharelink.socialMetaTagParameters?.title = "Welcome To NumberMate"
        
        sharelink.socialMetaTagParameters?.descriptionText = "Fellow player welcome to NumberMate. You were invited by \(String(describing: user.email))"
        sharelink.socialMetaTagParameters?.imageURL = URL(string: "https://d1i1eo6qmdfmdv.cloudfront.net/upload/mansory/3_supercars_los_angeles_racetrack.jpg")
        guard let longURL = sharelink.url else{return}
        
        sharelink.shorten() { (shortUrl, warningsArray, error) in
            if let err = error{
                print("OH No error \(err)")
                return
            }
            if let warnings = warningsArray{
                for warning in warnings{
                    print("FDL warning \(warning)")
                }
            }
            
            guard let url = shortUrl else{
                return
            }
            print("Here is Short url \(url)")
            self.inviteSheet(url: url)
        }
    }
    
    func inviteSheet(url: URL){
        let inviteText = "Hello, check out this number guessing monthly tournament app. The first place winner gets a reward by the end of the month."
        let activityVC = UIActivityViewController(activityItems: [inviteText,url], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
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
