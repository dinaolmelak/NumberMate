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
    var fire = Fire()
    let funcs = Function()
    
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
        hiddenNumber = funcs.playingNumberGenerator()
        print("DINAOL \(String(describing: hiddenNumber))")
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
        alert.addTextField { (textField)  in
            textField.text = ""
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let guessAction = UIAlertAction(title: "Guess", style: .default, handler: { [weak alert] (action) -> Void in
            let textField = alert?.textFields![0]
            guard ((textField?.text) != nil) else{
                return
            }
            if self.funcs.isRepeated(textField!.text!){
                self.funcs.showAlert(Title: "ERROR", Message: "Enter a number that is distinct",ViewController: self)
                return
            }
            let newNum = Int(textField!.text!)!
            let newNumGroup = self.funcs.checkGroup(guessNum: String(newNum), hiddenNum: String(hiddenNum))
            let newNumOrder = self.funcs.checkOrder(guessNum: String(newNum), hiddenNum: String(hiddenNum))
            
            let newGuess = guess(guess: newNum, group: newNumGroup, order: newNumOrder)
            self.guesses.append(newGuess)
            self.tableView.reloadData()
            if newNumGroup == 4 && newNumOrder == 4{
                self.funcs.showAlert(Title: "Congratulations!", Message: "You Won!!!",ViewController: self)
                self.AddGuessesTodb()
                self.addGuessButton.isEnabled = false
            }
        })
        alert.addAction(actionCancel)
        alert.addAction(guessAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func AddGuessesTodb(){
        let doc = fire.getPlayerDocID(FirestoreDatabase: db) { (string) in
            
        }
        print(doc)
//        if self.guesses.isEmpty != true{
//            fire.AddGuessesTodb(FirestoreDatabase: db, Guesses: self.guesses, HiddenNumber: self.hiddenNumber!, Document: doc)
//        }
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
