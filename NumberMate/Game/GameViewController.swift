//
//  GameViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import Lottie
import FirebaseFirestore
import FirebaseAuth
import GoogleMobileAds


class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var won = false
    var gameTimer:Timer?
    var minTimer: Timer?
    var minTime = 0
    var timeLeft = 60
    var started = false
    let funcs = Function()
    var firy: Fire!
    let ads = MobAds()
    var documentID: String?
    var hiddenNumber:  String?
    var guesses = [guess]()
    var db: Firestore!
    var animationView: AnimationView?
    var pointReward = NumberPoints()
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var bannerAd: GADBannerView!
    @IBOutlet weak var addGuessButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        firy = Fire()
        hiddenNumber = funcs.playingNumberGenerator()
        print("DINAOL \(String(describing: hiddenNumber))")
        // Do any additional setup after loading the view.
        ads.bannerDisplay(bannerAd, self)
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
        AddGuessesTodb(Won: won)
        if won{
            firy.increamentPoints(by: pointReward.gameWonPoint){ (error) in
                if let error = error{
                    print(error as Any)
                }else{
                    print("game Points increamented")
                }
            }
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
                self.funcs.showAlert(Title: "ERROR", Message: "Enter a 4 digit number that is distinct",ViewController: self)
                return
            }
            let newNum = textField!.text!
            let newNumGroup = self.funcs.checkGroup(guessNum: newNum, hiddenNum: String(hiddenNum))
            let newNumOrder = self.funcs.checkOrder(guessNum: newNum, hiddenNum: String(hiddenNum))
            
            let newGuess = guess(guess: newNum, group: newNumGroup, order: newNumOrder)
            self.guesses.insert(newGuess, at: 0)
            //self.guesses.append(newGuess)
            if self.started != true{
                self.started = true
                self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
                self.minTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onMinTimerFires), userInfo: nil, repeats: true)
            }
            self.tableView.reloadData()
            if newNumGroup == 4 && newNumOrder == 4{
                //self.funcs.showAlert(Title: "Congratulations!", Message: "You Won!!!",ViewController: self)
                //self.AddGuessesTodb()
                self.playWinAnimation()
                self.addGuessButton.isEnabled = false
                self.won = true
                self.gameTimer?.invalidate()
                self.minTimer?.invalidate()
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
    
    @objc func onMinTimerFires()
    {
        minTime += 1
    }
    
    func AddGuessesTodb(Won winning: Bool){
        if (guesses.count != 0){
            firy.addGameTodb(Guesses: guesses, HiddenNumber: hiddenNumber!, Won: winning)
            firy.increamentGameCount() { (error) in
                if let error = error{
                    print(error as Any)
                }else{
                    print("game increamented")
                }
            }
        }
        if(winning == true){
            firy.increamentWinCount { (error) in
                if let err = error{
                    print(err as Any)
                }else{
                    print("WON Game Saved")
                }
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        stopAnimation()
    }
    
    func playWinAnimation(){
        animationView = .init(name: "26182-happy-star")
        animationView!.frame = CGRect(x: view.frame.width / 4, y: view.frame.height / 3, width: 200, height: 200)
        animationView!.contentMode = .scaleAspectFit
        view.addSubview(animationView!)
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 2
        animationView!.play()
    }
    
    @objc func stopAnimation(){
        if animationView != nil{
            animationView!.stop()
            view.subviews.last?.removeFromSuperview()
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
