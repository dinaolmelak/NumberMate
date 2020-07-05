//
//  PlayersViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {
    // create players array of document ref
    // var myDocument!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // when vc loads
    // - setup a listener to Players collection
    // - get the documents and add it to players array
    
    
    // - create an @obj updateDoc() function sync every 30 sec to get the documents updated
    
    
    // - create an @obj opponentFound() function sync every sec to check if myDocument.opponent != nil
    //      -> show alert opponent wants to play: accept or reject
    //          -> if accept
    //              - set myDocument.status == "playing"
    //              - segue to gameVC
    //          -> if reject
    //              - set myDocument.opponent == nil
    
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

}
