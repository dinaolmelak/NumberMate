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

enum BombKeyFrames: CGFloat {

  case start = 16
  
  case end = 73
  
  case complete = 110
  
}

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var won = false
    var gameTimer:Timer?
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


    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var bombAnimationView: AnimationView!
    
    var animationView: AnimationView?
    var pointReward = NumberPoints()
    var initGuess = "Input 4 digit Guess"
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
        bombAnimationView.layer.cornerRadius = 5
        initBomb()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guesses.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuessCell", for: indexPath) as! GuessCell
            cell.inputGuess.text = initGuess
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuessCell", for: indexPath) as! GuessCell
            let guess = guesses[indexPath.row - 1]
            cell.group.alpha = 1
            cell.order.alpha = 1
            cell.guess.alpha = 1
            cell.inputGuess.alpha = 0.0
            cell.guess.text = String(guess.getGuess())
            cell.group.text = String(guess.getGroup())
            cell.order.text = String(guess.getOrder())
            return cell
        }
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        //AddGuessesTodb(Won: won)//adds the game to database
        if won{
            firy.increamentPoints(by: pointReward.gameWonPoint){ (error) in
                if let error = error{
                    print(error as Any)
                }else{
                    print("game Points increamented")
                }
            }
            firy.increamentWinCount { (error) in
                if let error = error{
                    self.funcs.showAlert(Title: "Error", Message: error.localizedDescription, ViewController: self)
                }
            }
        }
        if(guesses.count >= 1){
            firy.increamentGameCount { (error) in
                if let error = error{
                    self.funcs.showAlert(Title: "Error", Message: error.localizedDescription, ViewController: self)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapNumbers(_ sender: Any){
        if initGuess.count >= 4{
            initGuess = ""
        }
        let button = sender as! UIButton
        initGuess = initGuess + String(button.tag)
        tableView.reloadData()
    }
    @IBAction func onTapBackspace(_ sender: Any){
        if(initGuess == "Input Your Guess"){
            return
        }else if(initGuess.count > 0 && initGuess != "Input Your Guess"){
            initGuess.removeLast()
        }else if(initGuess.count == 0){
            initGuess = "Input Your Guess"
        }
        tableView.reloadData()
    }
    @IBAction func onTapGuessed(_ sender: Any){
        if(initGuess.count == 4 && !funcs.isRepeated(initGuess)){
        
            instructionsLabel.text = "Guess the number before bomb explodes to get more points"
        }else{
            instructionsLabel.text = "Please enter any 4 digit number that is distinct. Press ? for help"
            instructionsLabel.textColor = UIColor.red
            return
        }
        let hiddenNum = hiddenNumber!
        let newNumGroup = self.funcs.checkGroup(guessNum: initGuess, hiddenNum: String(hiddenNum))
        let newNumOrder = self.funcs.checkOrder(guessNum: initGuess, hiddenNum: String(hiddenNum))
        let newGuess = guess(guess: initGuess, group: newNumGroup, order: newNumOrder)
        self.guesses.insert(newGuess, at: 0)
        if self.started != true{
            self.started = true
            self.startBomb()
        }
        initGuess = "Input Your Guess"
        if newNumGroup == 4 && newNumOrder == 4{
            //self.funcs.showAlert(Title: "Congratulations!", Message: "You Won!!!",ViewController: self)
            //self.AddGuessesTodb()
            self.playWinAnimation()
            self.addGuessButton.isEnabled = false
            if gameTimer?.isValid == true{
                self.gameTimer?.invalidate()
                self.won = true
            }else{
                self.firy.increamentPoints(by: pointReward.numberFoundPoint){ (error) in
                    if let error = error{
                        print(error as Any)
                    }else{
                        print("game Points increamented")
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func didTapInfo(_ sender: Any) {
        // More Information
        
        
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timer.text = "\(timeLeft) sec"
        bombTicking(to: CGFloat(1 - Double(self.timeLeft) / 60.0))
        
        if(timeLeft < 30){
            timer.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        if timeLeft <= 0 {
            endBomb()
            gameTimer?.invalidate()
            self.instructionsLabel.text = "The bomb has Exploded! You can still get the number."
            gameTimer = nil
        }
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
    func initBomb(){
        bombAnimationView.loopMode = .loop
        bombAnimationView.animationSpeed = 0.5
    }
    func startBomb(){
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
        
//        bombAnimationView.play(fromFrame: 0, toFrame: BombKeyFrames.start.rawValue, loopMode: .none) { (_) in
//            self.bombTicking()
//        }
    }
    func bombTicking(to progress: CGFloat){
        
//        bombAnimationView.play(fromFrame: BombKeyFrames.start.rawValue, toFrame: BombKeyFrames.end.rawValue, loopMode: .none) {(_) in
//            self.endBomb()
//        }
        // 1. We get the range of frames specific for the progress from 0-100%
          
          let progressRange = BombKeyFrames.end.rawValue - BombKeyFrames.start.rawValue
          
          // 2. Then, we get the exact frame for the current progress
          
          let progressFrame = progressRange * progress
          
          // 3. Then we add the start frame to the progress frame
          // Considering the example that we start in 140, and we moved 30 frames in the progress, we should show frame 170 (140+30)
          
          let currentFrame = progressFrame + BombKeyFrames.start.rawValue
          
          // 4. Manually setting the current animation frame
          
          bombAnimationView.currentFrame = currentFrame
          
          print("Downloading \((progress))%")
        
    }
    func endBomb(){
        bombAnimationView.play(fromFrame: BombKeyFrames.end.rawValue, toFrame: BombKeyFrames.complete.rawValue, loopMode: .none)
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
