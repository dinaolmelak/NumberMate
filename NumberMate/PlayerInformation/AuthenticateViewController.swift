//
//  AuthenticateViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 10/30/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AuthenticateViewController: UIViewController {

    var displayAlerts = Function()
    var firy = Fire()
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let user = Auth.auth().currentUser
//        var credential: AuthCredential
//
//        user?.reauthenticate(with: credential, completion: { (<#AuthDataResult?#>, <#Error?#>) in
//            <#code#>
//        })
        if let user = Auth.auth().currentUser{
            emailLabel.text = user.email!
        }
    }
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDelete(_ sender: Any) {
        guard let currUser = Auth.auth().currentUser else {
            return
        }
        guard let pass = passTextField.text else{
            displayAlerts.showAlert(Title: "Error", Message: "Please check password", ViewController: self)
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: currUser.email!, password: pass)
        currUser.reauthenticate(with: credential) { (authDataResult, error) in
            if let err = error{
                let message = err.localizedDescription
                print(message)
            }else{
                self.firy.deleteCurrentUser { (error) in
                    if let err = error{
                        let message = err.localizedDescription
                        print(message)
                    }else{
  UserDefaults.standard.set(false, forKey: "isUser")
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "WelcomeViewController") as WelcomeViewController

                        vc.modalPresentationStyle = .fullScreen
                        self.navigationController?.popToRootViewController(animated: true)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                print("userAuthenticated")
            }
        }
    }
    
    
    

    // Prompt the user to re-provide their sign-in credentials

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
