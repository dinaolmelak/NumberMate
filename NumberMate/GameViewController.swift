//
//  GameViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseFirestore
struct guess{
    var guess: Int
    var group: Int
    var order: Int
    mutating func guess(_ inGuess: Int,_ inGroup: Int,_ inOrder: Int){
        guess = inGuess
        group = inGroup
        order = inOrder
    }
//    func setGuess(_ num: Int){
//        guess = num
//    }
    func getGuess() -> Int{
        return guess
    }
//    func setGroup(_ groupNum: Int){
//        group = groupNum
//    }
    func getGroup() -> Int{
        return group
    }
//    func setOrder(_ orderNum: Int){
//        order = orderNum
//    }
    func getOrder() -> Int{
        return order
    }
}

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db: Firestore!
    var opponentId: String?
    var myDoc: String!
    var opponentNumber: Int?
    var guesses = [guess]()
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
        let guess = guesses[indexPath.row]
        cell.guess.text = String(guess.getGuess())
        cell.group.text = String(guess.getGroup())
        cell.order.text = String(guess.getOrder())
        
        
        return cell
    }
    @IBAction func didTapAddGuess(_ sender: Any) {
        var newNum = Int()
        let hiddenNum = opponentNumber!
        let alert = UIAlertController(title: "New Guess", message: "Enter your guess NUMBER!", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
//        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
//            textField.text = "Some default text."
//        })
//        alert.addTextField { (textfield) in
//            newNum = Int(textfield.text!)!
//        }
        alert.addTextField { (textField)  in
            textField.text = ""
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let guessAction = UIAlertAction(title: "Guess", style: .default, handler: { [weak alert] (action) -> Void in
            let textField = alert?.textFields![0]
            newNum = Int(textField!.text!)!
            print("here is newNum")
            print(newNum)
            let newNumGroup = self.getGroup(guessNum: String(newNum), hiddenNum: String(hiddenNum))
            let newNumOrder = self.getOrder(guessNum: String(newNum), hiddenNum: String(hiddenNum))
            
            let newGuess = guess(guess: newNum, group: newNumGroup, order: newNumOrder)
            self.guesses.append(newGuess)
            self.tableView.reloadData()
        })
        alert.addAction(actionCancel)
        alert.addAction(guessAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
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
    func getGroup(guessNum: String, hiddenNum: String) -> Int{
        var counter = 0;
        
        for i in guessNum{
            for x in hiddenNum{
                if i == x{
                    counter += 1
                }
            }
        }
        
        return counter
    }
    func getOrder(guessNum: String, hiddenNum: String) -> Int{
        var counter = 0
        var myIndex = 0
        var uIndex = 0
        for i in guessNum{
            for x in hiddenNum{
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
