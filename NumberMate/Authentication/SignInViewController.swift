//
//  SignInViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/16/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    var db: Firestore!
    var firy: Fire!
    var signerFuncs = Function()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        firy = Fire()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func onResetPassword(_ sender: Any) {
        
        performSegue(withIdentifier: "ResetPasswordSegue", sender: self)
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSignIn(_ sender: Any) {
        
        let userEmail = emailTextfield.text!
        let userPass = passwordTextfield.text!
        firy.signIn(Email: userEmail, Password: userPass) { (authData, error) in
            if let err = error{
                let message = err.localizedDescription
                self.signerFuncs.showAlert(Title: "Error", Message: message, ViewController: self)
            } else{
                UserDefaults.standard.set(true, forKey: "isUser")
                
                self.performSegue(withIdentifier: "signinhomeSegue", sender: self)
            }
        }
        
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
