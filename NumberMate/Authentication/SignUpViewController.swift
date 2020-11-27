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
    var signInFunc = Function()
    var inviterUID: String?
    @IBOutlet weak var fnameTextfield: UITextField!
    @IBOutlet weak var lnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var displayTextfield: UITextField!
    
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
        if checkTextfield(fnameTextfield) == false{
            signInFunc.showAlert(Title: "Name Missing", Message: "Please Enter your first Name", ViewController: self)
            saveBool = false
        }
        if checkTextfield(lnameTextfield) == false{
            signInFunc.showAlert(Title: "Name Missing", Message: "Please Enter your Last Name", ViewController: self)
            saveBool = false
        }
        if checkTextfield(emailTextfield) == false{
            signInFunc.showAlert(Title: "Email Missing", Message: "Please Enter your email to receive the reward", ViewController: self)
            saveBool = false
        }
        
        if saveBool == true{
            // sign user Up
            firy.signUp(First: fnameTextfield.text!, Last: lnameTextfield.text!, DisplayName: displayTextfield.text != "" && displayTextfield.text != nil ? displayTextfield.text!: fnameTextfield.text!, Email: emailTextfield.text!, Password: passwordTextfield.text!) { (error) in
                if let err = error{
                    print(err)
                    let message = err.localizedDescription
                    self.signInFunc.showAlert(Title: "Error", Message: message, ViewController: self)
                    return
                }
            }
            UserDefaults.standard.set(true, forKey: "isUser")
            self.performSegue(withIdentifier: "SignedUpSegue", sender: self)
            print("Success Signed Up")
        }
        
        
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapGesture(_ sender: Any) {
        view.endEditing(true)
    }
    func checkTextfield(_ inField: UITextField)->Bool{
        //check textfield is empty or not
        if(inField.text == nil || inField.text == ""){
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
