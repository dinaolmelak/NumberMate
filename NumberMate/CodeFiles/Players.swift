//
//  File.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/24/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import Foundation
import UIKit


class playersInfo{
    var fname: String!
    var lname: String!
    var displayName: String!
    var email: String!
    var min_time_taken: Int!
    var points: Int!
    var game_count: Int!
    var won_game_count: Int!
    
    
    init(_fname first: String,_lname second:String,_dName dname:String,  _email inEmail: String,_minTime minTime: Int,_points inPoints: Int,_gameCount gameCount: Int,_WonGame winCount: Int){
        fname = first
        lname = second
        displayName = dname
        email = inEmail
        min_time_taken = minTime
        points = inPoints
        game_count = gameCount
        won_game_count = winCount
    }
}
