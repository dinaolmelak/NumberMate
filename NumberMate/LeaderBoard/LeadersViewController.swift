//
//  PlayersViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds

class LeadersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // create players array of document ref
    var myName: String?
    var players = [playersInfo]()//array of players docID
    let ads = MobAds()
    var firy: Fire!
    var db : Firestore!
    var funcs = Function()
    var activityIndicator = UIActivityIndicatorView()
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var simplePlayerBanner: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        firy = Fire()
        ads.bannerDisplay(simplePlayerBanner,self)
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        //onTimer()
        // MARK: - loading players----
        onRefresh()
        // listener.remove()
        // when vc appears
        // - setup a listener to Players collection
        // - get the documents and add it to players array
    }
    @IBAction func didTapCalender(_ sender: Any) {
        performSegue(withIdentifier: "MonthlyViewSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            return cell
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayTextCell", for: indexPath) as! DisplayTextCell
            cell.headerLabel.text = "The First Place Winner Get $25 Reward on Due Date!"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderCell", for: indexPath) as! LeaderCell
                    let playerDoc = players[indexPath.row - 2]
                    cell.playerNameLabel.text = playerDoc.displayName
                    cell.playerStatusLabel.text = String(playerDoc.points)
            return cell
        }
        
    }
    @objc func onRefresh() {
        // do necessary task here
        firy.getPlayers(){ (playerslist) in
            self.players = playerslist
            print(self.players)
            self.tableView.reloadData()
        }
        refresh()
    }
    func refresh(){
        funcs.run(after: 2) {
         self.refreshControl.endRefreshing()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        firy.detachListener()
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
    
