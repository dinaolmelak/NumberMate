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
    var settingFunc: Function!
    @IBOutlet weak var displayNameLabel: UITextField!
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
        UserDefaults.standard.set(false, forKey: "isUser")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "IntroPageViewController") as IntroPageViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true) {

        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        }
    }
    
    @IBAction func onChangePassword(_ sender: Any) {
        firy.changePassword(ViewController: self)
        print("onChangePassword")
    }
    @IBAction func onTapDelete(_ sender: Any) {
        performSegue(withIdentifier: "DeleteSegue", sender: self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.firy.detachListener()
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
