//
//  GameViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import GoogleMobileAds


class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let gameRewardPoints = 200
    var won = false
    @IBOutlet weak var timer: UILabel!
    var gameTimer:Timer?
    var timeLeft = 60
    var started = false
    let funcs = Function()
    let fire = Fire()
    @IBOutlet weak var bannerAd: GADBannerView!
    @IBOutlet weak var addGuessButton: UIButton!
    var documentID: String?
    var hiddenNumber:  Int?
    var guesses = [guess]()
    var db: Firestore!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
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
        if (won == true){
            AddGuessesTodb(Won: true)
            fire.increamentPoints(Firebase: db, by: gameRewardPoints) { (error) in
                if let error = error{
                    print(error)
                }
            }
        }else{
            AddGuessesTodb(Won: false)
        }
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
            if self.started != true{
                self.started = true
                self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
                
            }
            self.tableView.reloadData()
            if newNumGroup == 4 && newNumOrder == 4{
                self.funcs.showAlert(Title: "Congratulations!", Message: "You Won!!!",ViewController: self)
                //self.AddGuessesTodb()
                self.addGuessButton.isEnabled = false
                self.won = true
                self.gameTimer?.invalidate()
            }
        })
        alert.addAction(actionCancel)
        alert.addAction(guessAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timer.text = "\(timeLeft) sec"
        if(timeLeft < 30){
            timer.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        if timeLeft <= 0 {
            gameTimer?.invalidate()
            gameTimer = nil
        }
    }
    
    func AddGuessesTodb(Won winning: Bool){
        if (guesses.count != 0){
            fire.AddGuessesTodb(Firestore: db, Guesses: guesses, HiddenNumber: hiddenNumber!, Won: winning)
            fire.increamentGameCount(Firebase: db) { (error) in
                if let error = error{
                    print(error as Any)
                }else{
                    print("game increamented")
                }
            }
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
