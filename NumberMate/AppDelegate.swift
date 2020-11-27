//
//  AppDelegate.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDynamicLinks
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var funcs = Function()
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure()
        DynamicLinks.performDiagnostics(completion: nil)
        return true
    }

    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink){
        guard let url = dynamicLink.url else{
            print("Weird!, My dynamic link object has no url!")
            return
        }
        print("Your incoming parameter is \(url.absoluteString)")
        guard let component = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = component.queryItems else {return}
        let invitedBy = queryItems.first?.value
        print("first \(invitedBy)")
        let user = Auth.auth().currentUser
        if user == nil && invitedBy != nil{
            Auth.auth().signInAnonymously() { (user, error) in
                  if let user = user {
                    
                    print("first 1")
                    print("\(invitedBy)")
                    Firestore.firestore().settings = FirestoreSettings()
                    
                    Firestore.firestore().collection("Players").addDocument(data: ["userUID": user.user.uid,"referred_by":invitedBy])// .reference().child("users").child(user.uid)
                    print("Second \(invitedBy)")
                    //userRecord.child("referred_by").setValue(invitedBy)
                    
                  }else{
                    print(error)
                  }
                }
        }
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let urlExists = userActivity.webpageURL{
            print("here is url \(urlExists)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { [self] (dynamiclink, error) in
                guard error == nil else{
                    let message = error!.localizedDescription
                    print("found Error \(message)")
                    return
                }
                if let dynamiclink = dynamiclink{
                    self.handleIncomingDynamicLink(dynamiclink)
                }
            }
            if linkHandled{
                return true
            }else{
                return false
            }
        }
        return false
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return application(app, open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                         annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
        // Handle the deep link. For example, show the deep-linked content or
        // apply a promotional offer to the user's account.
        // ...
        self.handleIncomingDynamicLink(dynamicLink)
        print("Received url through customURLScheme \(dynamicLink.url?.absoluteString)")
        return true
      }
      return false
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

