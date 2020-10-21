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
    
    // Collection Strings
    let collectionString = "players"
    let winnerCollectionString = "Winner"
    // Keys for User CollectionString in Firestore
    let userFirstNameKey = "fname"
    let userLastNameKey = "lname"
    let userEmailKey = "email"
    let userDisplayNameKey = "dname"
    let userUIDKey = "userUID"
    let userGameCounterKey = "game_count"
    let userGamePointsKey = "points"
    let userGameMinTimeKey = "min_time_taken"
    let userGameSubCollection = "Games"
    
    // Keys for GameSubCollection in Firestore
    let gameDateKey = "game_Date"
    let gameWonKey = "win_status"
    let gameHiddenNumberKey = "hidden_number"
    let gameGuessKey = "guesses"
    let gameTimeKey = "game_time"
    
    // Keys for winnerCollection in Firestore
    let paymentDateKey = "paymentDate"
    let winnerEmailKey = "winner_email"
    let winnerBatchIDKey = "winnerBatchID"
    let winnerUidKey = "winner_uid"
    let winnerMoneyKey = "amountWon"
    let winnerFullNameKey = "winnerFullName"
    let winnerDisplayName = "winnerDisplayName"
    
    func getPlayerDocID(Firestore db:Firestore,completion: @escaping (String) -> Void) {
        let user = Auth.auth().currentUser
        db.collection(collectionString).whereField(self.userUIDKey, isEqualTo: user!.uid).getDocuments { (querySnap, error) in
            if error != nil{
                print(error as Any)
            }else{
                let snapshot = querySnap!.documents
                let id = snapshot[0].documentID
                completion(id)
            }
        }
    }
    func getWinnerDocID(Firestore db:Firestore,completion: @escaping (String) -> Void) {
        let user = Auth.auth().currentUser
        db.collection(collectionString).whereField(winnerUidKey, isEqualTo: user!.uid).getDocuments { (querySnap, error) in
            if error != nil{
                print(error as Any)
            }else{
                let snapshot = querySnap!.documents
                let id = snapshot[0].documentID
                completion(id)
            }
        }
    }
    func deleteCurrentUserData(Firestore db:Firestore){
        getPlayerDocID(Firestore: db) { (playerDocID) in
            db.collection(self.collectionString).document(playerDocID).delete()
        }
        getWinnerDocID(Firestore: db) { (winnerDocID) in
            db.collection(self.winnerCollectionString).document(winnerDocID).delete()
        }
        
    }
    func increamentPoints(Firebase db: Firestore, by npoint: Int, completion: @escaping(Error?)->Void){
        getPlayerInfo(Firestore: db) { (playerInfo) in
            let playerPoint = playerInfo.points
            self.getPlayerDocID(Firestore: db) { (docID) in
                db.collection(self.collectionString).document(docID).setData([self.userGamePointsKey : npoint + playerPoint!], merge: true) { (error) in
                    completion(error)
                }
            }
        }
        
    }
    
    func changeDisplayName(Firebase db: Firestore, by displayName: String, completion: @escaping(Error?)->Void){
        self.getPlayerDocID(Firestore: db) { (docID) in
            db.collection(self.collectionString).document(docID).setData([self.userDisplayNameKey : displayName], merge: true) { (error) in
                completion(error)
            }
        }
        
        
    }
    
    func increamentGameCount(Firebase db: Firestore, completion: @escaping(Error?)->Void){
        getPlayerInfo(Firestore: db) { (playerInfo) in
            let playerGames = playerInfo.game_count!
            self.getPlayerDocID(Firestore: db) { (docID) in
                db.collection(self.collectionString).document(docID).setData([self.userGameCounterKey : 1 + playerGames], merge: true) { (error) in
                    completion(error)
                }
            }
        }
        
    }
    func setMinTime(Firebase db: Firestore,by gTime:Int, completion: @escaping(Error?)->Void){
        getPlayerInfo(Firestore: db) { (playerInfo) in
            let playerTime = playerInfo.min_time_taken!
            self.getPlayerDocID(Firestore: db) { (docID) in
                db.collection(self.collectionString).document(docID).setData([self.userGameMinTimeKey : gTime + playerTime], merge: true) { (error) in
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
    
    func signUp(Firestore db:Firestore, First fName:String,Last lName:String,DisplayName dName:String, Email email:String,Password pass: String){
        Auth.auth().createUser(withEmail: email, password: pass) { (authDataResult, error) in
            if error != nil{
                print(error as Any)
            }else{
                var ref: DocumentReference? = nil
                ref = db.collection(self.collectionString).addDocument(data: [
                    self.userFirstNameKey: fName,
                    self.userLastNameKey: lName,
                    self.userDisplayNameKey: dName,
                    self.userEmailKey: email,
                    self.userGameCounterKey: 0,
                    self.userGamePointsKey: 0,
                    self.userGameMinTimeKey: 0.0,
                    self.userUIDKey: authDataResult!.user.uid
                 ]) { error in
                     if let error = error {
                         print("Error adding document: \(error)")
                     } else {
                         print("Document added with ID: \(ref!.documentID)")
                         Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                             if let user = authResult?.user {
                                 print("\(String(describing: user.email)) created!")
                             }else{
                                 print(error as Any)
                             }
                             
                         }
                         //self.myDocId = ref!.documentID
                         //self.performSegue(withIdentifier: "playersSegue", sender: self)
                     }
                 }
            }
        }
    }
    
    func listenPlayerInfo(Firestore db: Firestore, completion: @escaping (playersInfo) -> Void){
        getPlayerDocID(Firestore: db) { (docID) in
            db.collection(self.collectionString).document(docID).addSnapshotListener{ (documentSnap, error) in
                if error != nil{
                    print(error as Any)
                }else{
                    let document = documentSnap!.data()
                    let fname = document![self.userFirstNameKey] as! String
                    let lname = document![self.userLastNameKey] as! String
                    let dname = document![self.userDisplayNameKey] as! String
                    let email = document![self.userEmailKey] as! String
                    let points = document![self.userGamePointsKey] as! Int
                    let gameCounter = document![self.userGameCounterKey] as! Int
                    let timeTaken = document![self.userGameMinTimeKey] as! Int
                    
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
                    let fname = document![self.userFirstNameKey] as! String
                    let lname = document![self.userLastNameKey] as! String
                    let dname = document![self.userDisplayNameKey] as! String
                    let email = document![self.userEmailKey] as! String
                    let points = document![self.userGamePointsKey] as! Int
                    let gameCounter = document![self.userGameCounterKey] as! Int
                    let timeTaken = document![self.userGameMinTimeKey] as! Int
                    
                    let player = playersInfo.init(_fname: fname, _lname: lname, _dName: dname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounter)
                    completion(player)
                }
            }
        }
    }
    func getPlayersInfo(Firestore db:Firestore, completion: @escaping ([playersInfo]) -> Void){
        db.collection(collectionString).order(by: userGamePointsKey, descending: true).addSnapshotListener{ (querySnap, error) in
            if error != nil{
                print(error as Any)
            }else{
                var players = [playersInfo]()
                for doc in querySnap!.documents{
                            let playerArray = doc.data()
                    let fname = playerArray[self.userFirstNameKey] as! String
                    let lname = playerArray[self.userLastNameKey] as! String
                    let dname = playerArray[self.userDisplayNameKey] as! String
                    let email = playerArray[self.userEmailKey] as! String
                    let points = playerArray[self.userGamePointsKey] as! Int
                    let gameCounterKey = playerArray[self.userGameCounterKey] as! Int
                    let timeTaken = playerArray[self.userGameMinTimeKey] as! Int
                    
                    let playerInfo = playersInfo(_fname: fname, _lname: lname, _dName: dname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounterKey)
                            players.append(playerInfo)
                    
                }
                completion(players)
            }
        }
    }
    func listenEarnedPayments(Firestore db:Firestore, completion: @escaping ([Earned]) -> Void){
        db.collection(winnerCollectionString).order(by: paymentDateKey, descending: true).addSnapshotListener{ (querySnap, error) in
            if error != nil{
                print(error as Any)
            }else{
                let currentUserUID = Auth.auth().currentUser!.uid
                var earnedPayments = [Earned]()
                for doc in querySnap!.documents{
                    let paymentArray = doc.data()
                    let userUID = paymentArray[self.winnerUidKey] as! String
                    if(currentUserUID == userUID){
                        //Only collecting the earnings of the current User
                        let email = paymentArray[self.winnerEmailKey] as! String
                        let batchID = paymentArray[self.winnerBatchIDKey] as! Int
                        let paymentDate = paymentArray[self.paymentDateKey] as! Timestamp
                        let paymentAmount = paymentArray[self.winnerMoneyKey] as! Int
                        print("paymentDate\(paymentDate)")
                        let payment = Earned(_email: email, _uid: userUID, _batchid: batchID,_amount: paymentAmount)
                        earnedPayments.append(payment)
                    }
                    
                }
                completion(earnedPayments)
            }
        }
    }
    
    func addGuessesTodb(Firestore db:Firestore,Guesses guesses:[guess],HiddenNumber hNumber: Int,Won wonGame: Bool){
        getPlayerDocID(Firestore: db) { (docId) in
            let newData = db.collection(self.collectionString).document(docId).collection(self.userGameSubCollection).document()
            var guessedArray = [Int]()
            for guess in guesses{
                guessedArray.append(guess.guess)
            }
            newData.setData([self.gameGuessKey: guessedArray, self.gameWonKey: wonGame, self.gameHiddenNumberKey: hNumber,self.gameDateKey: Timestamp(date: Date())])

        }
    }
    func addPaidPlayerTodb(Firestore db:Firestore,SenderBatchID batchID: Int,WinnerFullName fllName:String, WinnerDisplayName wdName:String, WinnerEmail email:String,WinnerUID winnerUID:String,EarnedMoney wonAmount: Int){
        let newData = db.collection(self.winnerCollectionString).document()
        
        newData.setData([self.winnerFullNameKey:fllName,self.winnerDisplayName:wdName, self.winnerMoneyKey:wonAmount, self.winnerUidKey: winnerUID, self.winnerBatchIDKey: batchID, self.winnerEmailKey: email, self.paymentDateKey: Timestamp(date: Date())])
    }
    

    



}
