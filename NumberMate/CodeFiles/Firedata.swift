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
    let gameCounter = "game_count"
    let gamePoints = "points"
    let gameString = "games"
    
    let gameDate = "gameDate"
    let gameWon = "win_status"
    let hiddenNumber = "hidden_number"
    // func createUser()
    
    func getPlayerDocID(Firestore db:Firestore,completion: @escaping (String) -> Void) {
        db.collection(collectionString).whereField("userUID", isEqualTo: user!.uid).getDocuments { (querySnap, error) in
            if error != nil{
                print(error as Any)
            }else{
                let snapshot = querySnap!.documents
                let id = snapshot[0].documentID
                completion(id)
            }
        }
    }
    
    
    func increamentPoints(Firebase db: Firestore, by npoint: Int, completion: @escaping(Error?)->Void){
        getPlayerInfo(Firestore: db) { (playerInfo) in
            let playerPoint = playerInfo.points
            self.getPlayerDocID(Firestore: db) { (docID) in
                db.collection(self.collectionString).document(docID).setData([self.gamePoints : npoint + playerPoint!], merge: true) { (error) in
                    completion(error)
                }
            }
        }
        
    }
    
    func increamentGameCount(Firebase db: Firestore, completion: @escaping(Error?)->Void){
        getPlayerInfo(Firestore: db) { (playerInfo) in
            let playerGames = playerInfo.game_count!
            self.getPlayerDocID(Firestore: db) { (docID) in
                db.collection(self.collectionString).document(docID).setData([self.gameCounter : 1 + playerGames], merge: true) { (error) in
                    completion(error)
                }
            }
        }
        
    }
    func setMinTime(Firebase db: Firestore,by gTime:Int, completion: @escaping(Error?)->Void){
        getPlayerInfo(Firestore: db) { (playerInfo) in
            let playerTime = playerInfo.min_time_taken!
            self.getPlayerDocID(Firestore: db) { (docID) in
                db.collection(self.collectionString).document(docID).setData([self.gamePoints : gTime + playerTime], merge: true) { (error) in
                    completion(error)
                }
            }
        }
        
    }
    func signIn(Email email:String, Password pass: String, completion: @escaping(AuthDataResult?,Error?)-> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (authDataResult, error) in
            completion(authDataResult,error)
            
        }
    }
    
    func listenPlayerInfo(Firestore db: Firestore, completion: @escaping (playersInfo) -> Void){
        getPlayerDocID(Firestore: db) { (docID) in
            db.collection(self.collectionString).document(docID).addSnapshotListener{ (documentSnap, error) in
                if error != nil{
                    print(error as Any)
                }else{
                    let document = documentSnap!.data()
                    let fname = document!["fname"] as! String
                    let lname = document!["lname"] as! String
                    let dname = document!["dname"] as! String
                    let email = document!["email"] as! String
                    let points = document!["points"] as! Int
                    let gameCounter = document!["game_count"] as! Int
                    let timeTaken = document!["min_time_taken"] as! Int
                    
                    let player = playersInfo.init(_fname: fname, _lname: lname, _dName: dname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounter)
                    completion(player)
                }
            }
        }
    }
    
    func getPlayerInfo(Firestore db: Firestore, completion: @escaping (playersInfo) -> Void){
        getPlayerDocID(Firestore: db) { (docID) in
            db.collection(self.collectionString).document(docID).getDocument { (documentSnap, error) in
                if error != nil{
                    print(error as Any)
                }else{
                    let document = documentSnap!.data()
                    let fname = document!["fname"] as! String
                    let lname = document!["lname"] as! String
                    let dname = document!["dname"] as! String
                    let email = document!["email"] as! String
                    let points = document!["points"] as! Int
                    let gameCounter = document!["game_count"] as! Int
                    let timeTaken = document!["min_time_taken"] as! Int
                    
                    let player = playersInfo.init(_fname: fname, _lname: lname, _dName: dname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounter)
                    completion(player)
                }
            }
        }
    }
    func getPlayersInfo(Firestore db:Firestore, completion: @escaping ([playersInfo]) -> Void){
        db.collection(collectionString).order(by: gamePoints, descending: true).addSnapshotListener{ (querySnap, error) in
            if error != nil{
                print(error as Any)
            }else{
                var players = [playersInfo]()
                for doc in querySnap!.documents{
                            let playerArray = doc.data()
                            let fname = playerArray["fname"] as! String
                            let lname = playerArray["lname"] as! String
                            let dname = playerArray["dname"] as! String
                            let email = playerArray["email"] as! String
                            let points = playerArray["points"] as! Int
                            let gameCounter = playerArray["game_count"] as! Int
                            let timeTaken = playerArray["min_time_taken"] as! Int
                    
                    let playerInfo = playersInfo(_fname: fname, _lname: lname, _dName: dname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounter)
                            players.append(playerInfo)
                    
                }
                completion(players)
            }
        }
    }
    
    func AddGuessesTodb(Firestore db:Firestore,Guesses guesses:[guess],HiddenNumber hNumber: Int,Won wonGame: Bool){
        getPlayerDocID(Firestore: db) { (docId) in
            let newData = db.collection(self.collectionString).document(docId).collection(self.gameString).document()
            var guessedArray = [Int]()
            for guess in guesses{
                guessedArray.append(guess.guess)
            }
            newData.setData(["guesses": guessedArray, self.gameWon: wonGame, self.hiddenNumber: hNumber,self.gameDate: Timestamp(date: Date())])

        }
    }

    func deleteCurrentAccountData(){
        
    }

    



}
