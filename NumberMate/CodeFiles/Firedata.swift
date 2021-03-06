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
    enum Collections {
        case Players
        case Winners
        case Games
    }
    let dbFunc = Function()
    var myDB: Firestore!
    var handle: AuthStateDidChangeListenerHandle?
    var currentPlayer: User?
    // Collection Strings
    let playerCollectionString = "Players"
    var userCollectionRef: CollectionReference!
    let winnerCollectionString = "Winners"
    var winnerRef: CollectionReference!
    let gameCollectionString = "Games"
    var gameRef: CollectionReference!
    // Keys for User CollectionString in Firestore
    let userFirstNameKey = "fname"
    let userLastNameKey = "lname"
    let userEmailKey = "email"
    let userDisplayNameKey = "dname"
    let userUIDKey = "userUID"
    let userReferredbyKey = "invited_by"
    let userGameCounterKey = "game_count"
    let userWonGameCountKey = "won_game_count"
    let userGamePointsKey = "points"
    let userGameMinTimeKey = "min_time_taken"
    
    
    // Keys for GameSubCollection in Firestore
    let gameDateKey = "game_Date"
    let gameWonKey = "win_status"
    let gameHiddenNumberKey = "hidden_number"
    let gameGuessKey = "guesses"
    let gameTimeKey = "game_time"
    // userUIDKey is also included
    
    // Keys for winnerCollection in Firestore
    let paymentDateKey = "paymentDate"
    let winnerEmailKey = "winner_email"
    let winnerBatchIDKey = "winnerBatchID"
    let winnerUidKey = "winner_uid"
    let winnerMoneyKey = "amountWon"
    let winnerPointsKey = "winnerPoints"
    let winnerFullNameKey = "winnerFullName"
    let winnerDisplayNameKey = "winnerDisplayName"
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        myDB = Firestore.firestore()
        
        userCollectionRef = myDB.collection(playerCollectionString)
        winnerRef = myDB.collection(winnerCollectionString)
        gameRef = myDB.collection(gameCollectionString)
        handle = Auth.auth().addStateDidChangeListener { (authListened, user) in
            if let playingPlayer = authListened.currentUser{
                self.currentPlayer = playingPlayer
            }else{
                print("NO User")
                self.currentPlayer = nil
                return
            }
        }
        
    }
    
    func getPlayerDocID(FromCollection col:Collections,completion: @escaping (String) -> Void) {
        if let currentUser = currentPlayer{
            switch col {
            case .Players:
                userCollectionRef.whereField(self.userUIDKey, isEqualTo: currentUser.uid).getDocuments { (querySnap, error) in
                    
                    if error != nil{
                        print(error as Any)
                    }else{
                        let snapshot = querySnap!.documents
                        let id = snapshot[0].documentID
                        completion(id)
                    }
                    
                }
            case .Winners:
                winnerRef.whereField(self.winnerUidKey, isEqualTo: currentUser.uid).getDocuments { (querySnap, error) in
                    if error != nil{
                        print(error as Any)
                    }else{
                        let snapshot = querySnap!.documents
                        let id = snapshot[0].documentID
                        completion(id)
                    }
                }
                
            case .Games:
                gameRef.whereField(self.userUIDKey, isEqualTo: currentUser.uid).getDocuments { (querySnap, error) in
                    if error != nil{
                        print(error as Any)
                    }else{
                        let snapshot = querySnap!.documents
                        let id = snapshot[0].documentID
                        completion(id)
                    }
                }
            }
        } else {
            print("Trying to get DocID while there is No USEr getting DocID")
            
        }
        
    }
    
    func deleteCurrentUser(completion: @escaping(Error?)->Void){
        // Delete from the Players collection
        getPlayerDocID(FromCollection: .Players) { (playerDocID) in
            self.userCollectionRef.document(playerDocID).delete { (error1) in
                completion(error1)
            }
        }
        handle = Auth.auth().addStateDidChangeListener({ (authentication, UserOpt) in
            if UserOpt != nil {
                authentication.currentUser!.delete { (error) in
                    if let err = error{
                        print(err)
                    }else{
                        print("Deleted user account")
                    }
                }
            }
        })
        
        Auth.auth().removeStateDidChangeListener(handle!)
        
    }
    func increamentPoints(by npoint: Int, completion: @escaping(Error?)->Void){
        getPlayerInfo() { (playerInfo) in
            let playerPoint = playerInfo.points
            self.getPlayerDocID(FromCollection: .Players) { (docID) in
                self.userCollectionRef.document(docID).setData([self.userGamePointsKey : npoint + playerPoint!], merge: true) { (error) in
                    completion(error)
                }
            }
        }
        
    }
    
    func changeDisplayName(To displayName: String, completion: @escaping(Error?)->Void){
        self.getPlayerDocID(FromCollection: .Players) { (docID) in
            self.userCollectionRef.document(docID).setData([self.userDisplayNameKey : displayName], merge: true) { (error) in
                completion(error)
            }
        }
        
        
    }
    func changePassword(ViewController vc:UIViewController){
        if let currUser = currentPlayer{
            Auth.auth().sendPasswordReset(withEmail: currUser.email!) { error in
              // ...
                if let err = error{
                    let message = err.localizedDescription
                    self.dbFunc.showAlert(Title: "Error", Message: message, ViewController: vc)
                }else{
                    self.dbFunc.showAlert(Title: "Check your email", Message: "Password reset link has been sent to your email.", ViewController: vc)
                }
            }
        } else {
            //not signed in
            self.dbFunc.showAlert(Title: "Error", Message: "You are not currently signed in", ViewController: vc)
        }
        
    }
    func increamentGameCount(completion: @escaping(Error?)->Void){
        getPlayerInfo() { (playerInfo) in
            let playerGames = playerInfo.game_count!
            self.getPlayerDocID(FromCollection: .Players) { (docID) in
                self.userCollectionRef.document(docID).setData([self.userGameCounterKey : 1 + playerGames], merge: true) { (error) in
                    completion(error)
                }
            }
        }
    }
    func increamentWinCount(completion: @escaping(Error?)->Void){
        getPlayerInfo() { (playerInfo) in
            let playerGames = playerInfo.won_game_count!
            self.getPlayerDocID(FromCollection: .Players) { (docID) in
                self.userCollectionRef.document(docID).setData([self.userWonGameCountKey : 1 + playerGames], merge: true) { (error) in
                    completion(error)
                }
            }
        }
    }
    
    func setMinTime(To gTime:Int, completion: @escaping(Error?)->Void){
        getPlayerInfo() { (playerInfo) in
            let playerTime = playerInfo.min_time_taken!
            self.getPlayerDocID(FromCollection: .Players) { (docID) in
                if gTime < playerTime{
                    self.userCollectionRef.document(docID).setData([self.userGameMinTimeKey : gTime + playerTime], merge: true) { (error) in
                        completion(error)
                    }
                }
            }
        }
        
    }
    func signIn(Email email:String, Password pass: String, completion: @escaping(AuthDataResult?,Error?)-> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (authDataResult, error) in
            completion(authDataResult,error)
        }
    }
    
    func signUp(First fName:String,Last lName:String,DisplayName dName:String, Email email:String,Password pass: String, completion:@escaping(Error?)->Void){
        var saveData = [String:Any]()
            saveData = [
            self.userFirstNameKey: fName,
            self.userLastNameKey: lName,
            self.userDisplayNameKey: dName,
            self.userEmailKey: email,
            self.userGameCounterKey: 0,
            self.userWonGameCountKey: 0,
            self.userGamePointsKey: 0,
            self.userGameMinTimeKey: 0.0
         ]

            Auth.auth().createUser(withEmail: email, password: pass) { (authDataResult, error) in
                if error != nil{
                    completion(error)
                }else{
                    saveData[self.userUIDKey] = authDataResult!.user.uid
                    self.userCollectionRef.addDocument(data: saveData) { error in
                         if error != nil{
                            completion(error)
                         } else {
                            print(authDataResult!.user.email as Any)
                             //self.myDocId = ref!.documentID
                         }
                     }
                }
            }
        //}
    }
    
    func listenPlayerInfo(completion: @escaping (playersInfo) -> Void){
        getPlayerDocID(FromCollection: .Players) { (docID) in
            self.userCollectionRef.document(docID).getDocument{ (documentSnap, error) in
                if error != nil{
                    print(error as Any)
                }else{
                    if let document = documentSnap?.data(){
                        let fname = document[self.userFirstNameKey] as! String
                        let lname = document[self.userLastNameKey] as! String
                        let dname = document[self.userDisplayNameKey] as! String
                        let email = document[self.userEmailKey] as! String
                        let points = document[self.userGamePointsKey] as! Int
                        let gameCounter = document[self.userGameCounterKey] as! Int
                        let wonGameCounter = document[self.userWonGameCountKey] as! Int
                        let timeTaken = document[self.userGameMinTimeKey] as! Int
                                            
                        let player = playersInfo.init(_fname: fname, _lname: lname, _dName: dname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounter, _WonGame: wonGameCounter)
                        completion(player)
                    }else{
                        return
                    }
                    
                }
            }
        }
    }
    func getPlayerInfo(completion: @escaping (playersInfo) -> Void){
        getPlayerDocID(FromCollection: .Players) { (docID) in
            self.userCollectionRef.document(docID).getDocument { (documentSnap, error) in
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
                    let wonGameCounter = document![self.userWonGameCountKey] as! Int
                    let timeTaken = document![self.userGameMinTimeKey] as! Int
                    
                    let player = playersInfo.init(_fname: fname, _lname: lname, _dName: dname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounter, _WonGame: wonGameCounter)
                    completion(player)
                }
            }
        }
    }
    func getPlayers(completion: @escaping ([playersInfo]) -> Void){
        userCollectionRef.order(by: userGamePointsKey, descending: true).limit(to: 25).addSnapshotListener{ (querySnap, error) in
            if error != nil{
                print(error as Any)
            }else{
                guard querySnap?.documents != nil else {return}
                var players = [playersInfo]()
                for doc in querySnap!.documents{
                    let playerArray = doc.data()
                    let fname = playerArray[self.userFirstNameKey] as! String
                    let lname = playerArray[self.userLastNameKey] as! String
                    let dname = playerArray[self.userDisplayNameKey] as! String
                    let email = playerArray[self.userEmailKey] as! String
                    let points = playerArray[self.userGamePointsKey] as! Int
                    let gameCounterKey = playerArray[self.userGameCounterKey] as! Int
                    let wonGameCounter = playerArray[self.userWonGameCountKey] as! Int
                    let timeTaken = playerArray[self.userGameMinTimeKey] as! Int
                    
                    let playerInfo = playersInfo(_fname: fname, _lname: lname, _dName: dname, _email: email, _minTime: timeTaken, _points: points, _gameCount: gameCounterKey, _WonGame: wonGameCounter)
                            players.append(playerInfo)
                    
                }
                completion(players)
            }
        }
    }
    func listenEarnedPayments(completion: @escaping ([Earned]) -> Void){
        winnerRef.order(by: paymentDateKey, descending: true).addSnapshotListener{ (querySnap, error) in
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
                        //let paymentDate = paymentArray[self.paymentDateKey] as! Timestamp
                        let paymentAmount = paymentArray[self.winnerMoneyKey] as! Int
                        let pointsWon = paymentArray[self.winnerPointsKey] as! Int
                        //print("paymentDate\(paymentDate)")
                        let payment = Earned(_email: email, _uid: userUID, _batchid: batchID,_amount: paymentAmount, _points: pointsWon)
                        earnedPayments.append(payment)
                    }
                    
                }
                completion(earnedPayments)
            }
        }
    }
    
    func addNewUserDataTodb(_ invitedby:String,_ newUser:String){
        let newData = userCollectionRef.document()
        newData.setData([userUIDKey:invitedby,userReferredbyKey:newUser])
    }
    
    func addGameTodb(Guesses guesses:[guess],HiddenNumber hNumber: String,Won wonGame: Bool){
            let currentUserUid = Auth.auth().currentUser!.uid
            let newData = gameRef.document()
            var guessedArray = [String]()
            for guess in guesses{
                guessedArray.append(guess.guess)
            }
            newData.setData([self.userUIDKey: currentUserUid, self.gameGuessKey: guessedArray, self.gameWonKey: wonGame, self.gameHiddenNumberKey: hNumber,self.gameDateKey: Date()])
        
    }
    func addPaidPlayerTodb(SenderBatchID batchID: Int,WinnerFullName fllName:String, WinnerDisplayName wdName:String, WinnerEmail email:String,WinnerUID winnerUID:String,EarnedMoney wonAmount: Int,PointsWon wonPoints: Int){
        let newData = winnerRef.document()
        
        newData.setData([self.winnerFullNameKey:fllName,self.winnerDisplayNameKey:wdName, self.winnerMoneyKey:wonAmount, self.winnerUidKey: winnerUID, self.winnerBatchIDKey: batchID,self.winnerPointsKey:wonPoints, self.winnerEmailKey: email, self.paymentDateKey: Timestamp(date: Date())])
    }
    

    
    deinit {
        Auth.auth().removeStateDidChangeListener(handle!)
        detachListener()
    }
    func detachListener() {
        // [START detach_listener]
        let listener = myDB.collection(playerCollectionString).addSnapshotListener { querySnapshot, error in
            // [START_EXCLUDE]
            // [END_EXCLUDE]
        }

        // ...
        // Stop listening to changes
        listener.remove()
        // [END detach_listener]
    }

}
