//
//  Fire.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/29/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Fire{
    
    func getPlayersInfo(FirestoreDatabase db:Firestore) -> [playersInfo]{
        var playersArray = [playersInfo]()
        db.collection("players").getDocuments { (querySnapshot, error) in
            if error != nil{
                print(error)
            }else{
                for document in querySnapshot!.documents{
                    print ("Loaded____\(document.data())")
                    let playerArray = document.data()
                    // let doc = document.data()
                    let fname = playerArray["fname"] as! String
                    let lname = playerArray["lname"] as! String
                    let email = playerArray["email"] as! String
                    let points = playerArray["points"] as! Int
                    let gameCounter = playerArray["game_count"] as! Int
                    let timeTaken = playerArray["min_time_taken"] as! Int
                    
                    let playerInfo = playersInfo(_fname: fname, _lname: lname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounter)
                    playersArray.append(playerInfo)
                }
            
            }
        }
        return playersArray
    }
    
}
