//
//  CalendarViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/24/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseAuth
import FirebaseFirestore

class MonthViewController: UIViewController{
   
    var paying = Payment()
    var db: Firestore!
    var fire = Fire()
    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payPerson(_ sender: Any) {
        let generateID = Function()
        let generatedBatchID = generateID.batchIDGenerator()
        //let userEmail = Auth.auth().currentUser!.email!
        let userUID = Auth.auth().currentUser
        let userEmail = "sb-mnb763321420@personal.example.com"
        print(generatedBatchID)
        paying.getToken { (token) in
            self.paying.pay(SenderBatchID: generatedBatchID, Token: token, Email: userEmail)
        }
        fire.getPlayerInfo(Firestore: db) { (playerInfo) in
            self.fire.addPaidPlayerTodb(Firestore: self.db, SenderBatchID: generatedBatchID, WinnerFullName: playerInfo.fname + " " + playerInfo.lname, WinnerDisplayName: playerInfo.displayName, WinnerEmail: userEmail, WinnerUID: userUID!.uid, EarnedMoney: self.paying.price)
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
