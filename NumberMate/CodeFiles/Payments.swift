//
//  Payments.swift
//  NumberMate
//
//  Created by Dinaol Melak on 10/16/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import Foundation


class Earned {
    //var date: Date!
    var batchid: Int!
    var userid: String!
    var email: String!
    var amountEarned: Int!
    var points: Int!
    
    init(_email inEmail: String,_uid userID: String,_batchid batchID: Int,/*_date indate: Date,*/_amount amount:Int,_points pointsWon: Int){
        email = inEmail
        batchid = batchID
        userid = userID
        //date = indate
        amountEarned = amount
        points = pointsWon
    }
}
