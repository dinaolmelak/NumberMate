//
//  GameViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseFirestore

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db: Firestore!
    var opponentId: String?
    var myDoc: String!
    var opponentNumber: Int?
    var guesses = [Int]()
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        // set opponentLabel from myDocumentRef.opponent Name
        // set oppoenetNumber from myDocumentRef.opponent Number
        let docRef = db.collection("players").document(opponentId!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print(document.data()!)
                let doc = document.data()
                let name = doc!["name"] as! String
                let oppNum = doc!["hidden_number"] as! Int
                self.opponentNumber = oppNum
                self.opponentNameLabel.text = name
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuessCell", for: indexPath) as! GuessCell
        //let guess = guesses[indexPath.row]
        
        
        
        return cell
    }
    @IBAction func didTapAddGuess(_ sender: Any) {
        
        
    }
    
    func isRepeated(ofString inString: String)->Bool{
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
    func getGroup(myNum: String, uNum: String) -> Int{
        var counter = 0;
        
        for i in myNum{
            for x in uNum{
                if i == x{
                    counter += 1
                }
            }
        }
        
        return counter
    }
    func getOrder(myNum: String, uNum: String) -> Int{
        var counter = 0
        var myIndex = 0
        var uIndex = 0
        for i in myNum{
            for x in uNum{
                if i == x && myIndex == uIndex{
                    counter += 1
                }
                uIndex += 1
            }
            myIndex += 1
            uIndex = 0
        }
        
        return counter
    }
    // for each cells in tableView
    // when tapped add guess
        // check guess group and order against opponentNumber
        // disable the cell and store number in guesses array
        // if group and order of guess == 4
        //      -> display winner alert
        //      -> if name !exists in winners collection
        //          store name in winners collection and numWin = 1
        //      -> else numWin += 1
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
