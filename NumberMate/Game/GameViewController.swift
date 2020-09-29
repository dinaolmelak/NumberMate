//
//  GameViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db: Firestore!
    
    @IBOutlet weak var addGuessButton: UIButton!
    var documentID: String?
    var hiddenNumber:  Int?
    var guesses = [guess]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        // [END setup]
        hiddenNumber = playingNumberGenerator()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
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
    @IBAction func onTapBack(_ sender: Any) {
        AddGuessesTodb()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapAddGuess(_ sender: Any) {
        
        let hiddenNum = hiddenNumber!
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
            guard ((textField?.text) != nil) else{
                return
            }
            if self.isRepeated(textField!.text!){
                self.showAlert("ERROR", "Enter a number that is distinct")
                return
            }
            let newNum = Int(textField!.text!)!
            let newNumGroup = self.getGroup(guessNum: String(newNum), hiddenNum: String(hiddenNum))
            let newNumOrder = self.getOrder(guessNum: String(newNum), hiddenNum: String(hiddenNum))
            
            let newGuess = guess(guess: newNum, group: newNumGroup, order: newNumOrder)
            self.guesses.append(newGuess)
            self.tableView.reloadData()
            if newNumGroup == 4 && newNumOrder == 4{
                self.showAlert("Congratulations!", "You Won!!!")
                self.AddGuessesTodb()
                self.addGuessButton.isEnabled = false
            }
        })
        alert.addAction(actionCancel)
        alert.addAction(guessAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
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
    
    
    func playingNumberGenerator()->Int{
        let digits = 0...9
        // Shuffle them
        let shuffledDigits = digits.shuffled()

         // Take the number of digits you would like
        let fourDigits = shuffledDigits.prefix(4)

         // Add them up with place values
        let value = fourDigits.reduce(0) {
             $0*10 + $1
        }
        return value
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
    func showAlert(_ title: String,_ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func AddGuessesTodb(){
        if Auth.auth().currentUser != nil {
          // User is signed in.
            let user = Auth.auth().currentUser
            db.collection("players").whereField("userUID", isEqualTo: user!.uid).getDocuments { (querySnapshot, error) in
                if error != nil {
                    print(error!)
                }else{
                    let snapshot = querySnapshot!.documents
                    let docID = snapshot[0].documentID
                    
                    let newData = self.db.collection("players").document(docID).collection("games").document()
                    var guessedArray = [Int]()
                    for guess in self.guesses{
                        guessedArray.append(guess.guess)
                    }
                    if self.guesses.isEmpty != true{
                        newData.setData(["guesses": guessedArray,"hidden_number": self.hiddenNumber!,"gameDate": Timestamp(date: Date())])
                    }
                }
            }
        } else {
            showAlert("Account", "User not signed in")
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
