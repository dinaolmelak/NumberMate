//
//  FormViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FormViewController: UIViewController {
    var db: Firestore!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    var myDocId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        nameText.text = nil
        numberText.text = nil
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapGo(_ sender: Any) {
        // When lets go is tapped
        // 1. create a collection(players) in the db
        // 2. create a document in players containing nametext, numberText, isOnline: true and opponent: nil
        // pass document to myDocument to players VC
        if nameText.text == nil || nameText.text == ""{
            showAlert("Name missing!", "Please enter your name")
        }
        if nameText.text == nil || nameText.text == ""{
            showAlert("Number missing!", "Please enter a 4 digit Number")
        }
        if isRepeated(numberText.text!){
            showAlert("Number Repeated!", "Please enter a 4 digit Number that has no repeating digits(3487✅,1226❌)")
        }
        var ref: DocumentReference? = nil
        ref = db.collection("players").addDocument(data: [
            "name": nameText.text!,
            "hidden_number": Int(numberText.text!)!,
            "isOnline": true,
            "isPlaying": false
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.myDocId = ref!.documentID
                self.performSegue(withIdentifier: "playersSegue", sender: self)
            }
        }
    }
    
    func showAlert(_ title: String,_ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    func isRepeated(_ inString: String)->Bool{
        var num = 0
        for i in inString {
            for x in inString{
                if i == x{
                    num += 1
                }
            }
        }
        if num == 4{
            return false//their is no number repeating
        }else{
            return true
        }
        //return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let playersVC = segue.destination as! PlayersViewController
        playersVC.myDocument = self.myDocId
        // Pass the selected object to the new view controller.
    }
    

}
