//
//  SettingsViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/24/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingsViewController: UIViewController {

    var firy: Fire!
    var db: Firestore!
    
    @IBOutlet weak var displayNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        firy = Fire()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onDone(_ sender: Any) {
        // update account
        if(displayNameLabel.text != nil && displayNameLabel.text != ""){
            firy.changeDisplayName(To: displayNameLabel.text!) { (error) in
                if (error != nil){
                    print(error as Any)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSignOut(_ sender: Any) {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        //UserDefaults.standard.set(false, forKey: "isUser")
//        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "SignInViewController") as SignInViewController
//        vc.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapDelete(_ sender: Any) {
        // delete account
        //firy.deleteCurrentUser(Firestore: db)
        //UserDefaults.standard.set(false, forKey: "isUser")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpViewController") as SignUpViewController
        vc.dismiss(animated: true, completion: nil)
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
