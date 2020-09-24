//
//  PlayersViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PlayersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // create players array of document ref
    var db: Firestore!
    var myName: String?
    var players = [playersInfo]()//array of players docID
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        tableView.delegate = self
        tableView.dataSource = self
//      Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        db.collection("players").getDocuments { (querySnapshot, error) in
            if error != nil{
                    print(error as Any)
            }else{
                for document in querySnapshot!.documents{
                    print ("Loaded____\(document.data())")
                    let playerArray = document.data()
                    // let doc = document.data()
                    let fname = playerArray["fname"] as! String
                    let lname = playerArray["lname"] as! String
                    let email = playerArray["email"] as! String
                    let points = playerArray["points"] as! Int
                    let gameCounter = playerArray["game_count"] as! Int
                    let timeTaken = playerArray["min_time_taken"] as! Int
                    
                    let playerInfo = playersInfo(_fname: fname, _lname: lname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounter)
                    self.players.append(playerInfo)
                }
                self.tableView.reloadData()
            }
        }

        
    }
    override func viewDidAppear(_ animated: Bool) {
        //onTimer()
        // MARK: - loading players----
        
        db.collection("players").addSnapshotListener { (QuerySnapshot, error) in
            if error != nil{
                print(error as Any)
            }else{
                //print(QuerySnapshot!)
                for document in QuerySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                }
            }
        }
        
        // listener.remove()
        
        // when vc appears
        // - setup a listener to Players collection
        // - get the documents and add it to players array
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        let playerDoc = players[indexPath.row]
        cell.playerNameLabel.text = playerDoc.fname + " " + playerDoc.lname
        cell.playerStatusLabel.text = String(playerDoc.points)
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let gameVC = segue.destination as! GameViewController
//        let playerCell = sender as! PlayerCell
//        let indexPath = tableView.indexPath(for: playerCell)!
//        let opponentId = players[indexPath.row]
//        gameVC.myDoc = self.myDocument
//        gameVC.opponentId = opponentId
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
    
