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
    var players = [String]()//array of players docID
    var myDocument: String?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(myDocument as Any)
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        tableView.delegate = self
        tableView.dataSource = self
//        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        let docRef = db.collection("players").document(myDocument!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let doc = document.data()
                let name = doc!["name"] as! String
                self.myName = name
            } else {
                //print("Document does not exist")
            }
        }
        
    }
    /*
    @objc func onTimer(){
        db.collection("players").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.players.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.players.append(document.documentID)
                    self.tableView.reloadData()
                }
            }
        }

    }
    */
    override func viewDidAppear(_ animated: Bool) {
        //onTimer()
        db.collection("players").addSnapshotListener { (QuerySnapshot, error) in
            if error != nil{
                print(error as Any)
            }else{
                print(QuerySnapshot!)
                for document in QuerySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.players.append(document.documentID)
                    self.tableView.reloadData()
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
        let docRef = db.collection("players").document(playerDoc)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let doc = document.data()
                let name = doc!["name"] as! String
                let isOnline = doc!["isOnline"] as! Bool
                let isPlaying = doc!["isPlaying"] as! Bool
                cell.playerNameLabel.text = name
                if isOnline{
                    cell.playerStatusLabel.text = "online"
                }else if isPlaying{
                    cell.playerStatusLabel.text = "playing"
                }else{
                    cell.playerStatusLabel.text = "offline"
                }
            } else {
                print("Document does not exist")
            }
        }
        return cell
    }
    // when loading tableView
    // - for tableView size return players.count
    
    // when loading up each players from players.document
    // -  if name == myName:
    //      -> disable that cell
    //      -> set status to online
    // -  if name != myName && isStatus == "online"
    //      -> enable that cell
    //      -> set status to online
    // -  if name != myName  and isStatus == "offline"
    //      -> disable that cell
    //      -> set status to offline
    // -  if name != myName  and isStatus == "playing"
    //      -> disable that cell
    //      -> set status to playing

    // when tapped on cell
    //      -> get player.document
    //          -> set myDocument.opponent = player.document.name
    //          -> set myDocument.opponent_number = player.document.hidden_number
    //          -> (optional) myDocument.opponent_id = player.document
    //      -> pass myDocument and segue to game
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // Hold off on updateDoc()
            // - create an @obj updateDoc() function sync every 30 sec to get the documents updated
            
            // Hold off on opponentFound()
            // - create an @obj opponentFound() function sync every sec to check if myDocument.opponent != nil
            //      -> show alert opponent wants to play: accept or reject
            //          -> if accept
            //              - set myDocument.status == "playing"
            //              - segue to gameVC
            //          -> if reject
            //              - set myDocument.opponent == nil
}
