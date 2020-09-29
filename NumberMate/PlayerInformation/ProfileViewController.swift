//
//  ProfilePicViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/15/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleMobileAds
import FirebaseFirestore

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var simpleBannerAd: GADBannerView!
    var db: Firestore!
    var ad = MobAds()
    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var minimumTimeLabel: UILabel!
    @IBOutlet weak var gameCount: UILabel!
    @IBOutlet weak var npointsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //---
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        //----
        // Do any additional setup after loading the view.
        ad.bannerDisplay(simpleBannerAd, self)
        
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        getDataFromdb()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = gamesTableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as UITableViewCell
        let cell = UITableViewCell()
        
        return cell
    }
    @IBAction func didTapSetting(_ sender: Any) {
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    func getDataFromdb(){
        if Auth.auth().currentUser != nil{
            //User is signed in.
            let user = Auth.auth().currentUser
            db.collection("players").whereField("userUID", isEqualTo: user!.uid).getDocuments { (querySnapshot, error) in
                if error != nil{
                    print(error!)
                }else{
                    let snapshot = querySnapshot!.documents
                    let docID = snapshot[0].documentID
                    
                    self.db.collection("players").document(docID)
                        .addSnapshotListener { documentSnapshot, error in
                            guard let document = documentSnapshot else {
                                print("Error fetching document: \(error!)")
                                return
                            }
                            guard let data = document.data() else {
                                print("Document data was empty.")
                                return
                            }
                            print("Current User data: \(data)")
                            let fname = data["fname"] as! String
                            let lname = data["lname"] as! String
                            let email = data["email"] as! String
                            let minTime = data["min_time_taken"] as! Int
                            let npoint = data["points"] as! Int
                            
                            let gameCount = data["game_count"] as! Int
                            self.setDataToLabel(FName: fname, LName: lname, email: email, Points: npoint, GameCount: gameCount, TimeTaken: minTime)
                            //-----
                            
                    }
                }
            }
        }
        else{
            //User is not signed in
        }
    }
    
    func setDataToLabel(FName fName: String, LName lName: String, email inEmail: String,Points inPoint: Int, GameCount inGame: Int, TimeTaken timeTaken: Int){
        fullNameLabel.text = fName + " " + lName
        emailLabel.text = inEmail
        npointsLabel.text = String(inPoint)
        minimumTimeLabel.text = String(timeTaken)
        gameCount.text = String(inGame)
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
