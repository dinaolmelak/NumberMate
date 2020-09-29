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
    @IBOutlet weak var fnameTextfield: UITextField!
    @IBOutlet weak var lnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
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
            Auth.auth().createUser(withEmail: self.emailTextfield.text!, password: self.passwordTextfield.text!) { authResult, error in
                if let user = authResult?.user {
                    print("\(String(describing: user.email)) created!")
                    let userUID = authResult!.user.uid
                    var ref: DocumentReference? = nil
                    ref = self.db.collection("players").addDocument(data: [
                        "fname": self.fnameTextfield.text!,
                        "lname": self.lnameTextfield.text!,
                        "email": self.emailTextfield.text!,
                        "userUID": userUID,
                        "start_date": Timestamp(date: Date()),
                        "points": 0,
                        "min_time_taken": 0,
                        "game_count": 0
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")

                        }
                    }
                    
                }else{
                    print(error as Any)
                }
                
            }
            
        }
        UserDefaults.standard.set(true, forKey: "isUser")
        self.performSegue(withIdentifier: "SignedUpSegue", sender: self)
        
    }
    
    @IBAction func didTapHaveAccount(_ sender: Any) {
        performSegue(withIdentifier: "signInSegue", sender: self)
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
