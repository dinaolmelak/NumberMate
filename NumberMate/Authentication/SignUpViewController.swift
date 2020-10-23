//
//  SignUpViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/16/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class SignUpViewController: UIViewController {
    // email and password
    var db: Firestore!
    var firy: Fire!
    @IBOutlet weak var fnameTextfield: UITextField!
    @IBOutlet weak var lnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        firy = Fire()
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        var saveBool = true
        if promptTextfield(fnameTextfield, "First Name Required!", "please fill in your first Name") == false{
            saveBool = false
        }
        if promptTextfield(lnameTextfield, "Last Name Required!", "please fill in your first Name") == false{
            saveBool = false
        }
        
        if saveBool == true{
            // sign user Up
            firy.signUp(First: fnameTextfield.text!, Last: lnameTextfield.text!, DisplayName: "King", Email: emailTextfield.text!, Password: passwordTextfield.text!, ViewController: self) { (creationState) in
                if creationState{
                    UserDefaults.standard.set(true, forKey: "isUser")
                    self.performSegue(withIdentifier: "SignedUpSegue", sender: self)
                }
            }
        }
        
        
    }
    
    @IBAction func didTapHaveAccount(_ sender: Any) {
        self.performSegue(withIdentifier: "signInSegue", sender: self)
    }
            
    
    @IBAction func didTapGesture(_ sender: Any) {
        view.endEditing(true)
    }
    func promptTextfield(_ inField: UITextField,_ title: String,_ message: String)->Bool{
        //check textfield and prompt for value
        if(inField.text == nil || inField.text == ""){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true)
            return false
        }
        return true
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
