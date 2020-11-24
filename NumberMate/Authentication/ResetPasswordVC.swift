//
//  ResetPasswordVC.swift
//  NumberMate
//
//  Created by Dinaol Melak on 11/21/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordVC: UIViewController {

    var funcs = Function()
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onResetPassword(_ sender: Any) {
        if let email = emailTextField.text{
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let err = error{
                    self.funcs.showAlert(Title: "Error", Message: err.localizedDescription, ViewController: self)
                }else{
                    self.funcs.showAlert(Title: "Success", Message: "Password reset link has been sent to your email. Please check your email.", ViewController: self)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
