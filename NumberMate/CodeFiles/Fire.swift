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
    let user = Auth.auth().currentUser
    let collectionString = "players"
    let gameString = "games"
    let hiddenNumber = "hidden_number"
    let gameDate = "gameDate"
    let gamePoints = "points"
    func getPlayerDocID(FirestoreDatabase db:Firestore, completion: @escaping (String) -> Void) {
        var docID = ""
        db.collection(collectionString).whereField("userUID", isEqualTo: user!.uid).getDocuments { (querySnapshot, error) in
            if error != nil{
                print(error as Any)
            }else{
                let snapshot = querySnapshot!.documents
                let id = snapshot[0].documentID
                docID = id
                print("getid___\(docID)")
                completion(docID)
            }
        }
        
    }
    
    func getPlayersInfo(FirestoreDatabase db:Firestore, completion: @escaping ([playersInfo]) -> Void){
        var pl = [playersInfo]()
        db.collection(collectionString).order(by: gamePoints).getDocuments { (querySnapshot, error) in
            if error != nil{
                print(error as Any)
            }else{
                // [playerInfo]()
                for document in querySnapshot!.documents{
                    //print ("Loaded____\(document.data())")
                    let playerArray = document.data()
                    let fname = playerArray["fname"] as! String
                    let lname = playerArray["lname"] as! String
                    let email = playerArray["email"] as! String
                    let points = playerArray["points"] as! Int
                    let gameCounter = playerArray["game_count"] as! Int
                    let timeTaken = playerArray["min_time_taken"] as! Int
                    
                    let playerInfo = playersInfo(_fname: fname, _lname: lname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounter)
                    pl.append(playerInfo)
                    //return another
                    completion(pl)
                }
            }
            
        }
    }
    
    func AddGuessesTodb(FirestoreDatabase db: Firestore,Guesses guesses:[guess],HiddenNumber hNumber: Int,Document doc:String){
        let newData = db.collection(collectionString).document(doc).collection(gameString).document()
        var guessedArray = [Int]()
        for guess in guesses{
            guessedArray.append(guess.guess)
        }
        newData.setData(["guesses": guessedArray, hiddenNumber: hNumber,gameDate: Timestamp(date: Date())])
    }






}
