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
        UserDefaults.standard.set(false, forKey: "isUser")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "IntroPageViewController") as IntroPageViewController
        present(vc, animated: true) {

        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        }
    }
    
    @IBAction func onChangePassword(_ sender: Any) {
        //firy.changePassword(NewPassword: <#T##String#>, ViewController: <#T##UIViewController#>, completion: <#T##(Error?) -> Void#>)
        print("onChangePassword")
    }
    @IBAction func onTapDelete(_ sender: Any) {
        // delete account
        //firy.deleteCurrentUser(Firestore: db)
        UserDefaults.standard.set(false, forKey: "isUser")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "IntroPageViewController") as IntroPageViewController
        self.present(vc, animated: true) {
            
            print("delete->Presented VC")
            self.firy.deleteCurrentUser { (error) in
                if let err = error{
                    print(err)
                    //let message = err.localizedDescription
                    
                    //self.settingFunc.showAlert(Title: "Error", Message: message, ViewController: self)
                }else{
                    print("Deleted")
                    //self.settingFunc.showAlert(Title: "Success", Message: "Your account was successfully Deleted!", ViewController: self)
                }
            }
            do { try Auth.auth().signOut() }
            catch { print("already logged out") }
        }
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
