//
//  Guess.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/24/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import Foundation
struct guess{
    var guess: String
    var group: Int
    var order: Int
    mutating func guess(_ inGuess: String,_ inGroup: Int,_ inOrder: Int){
        guess = inGuess
        group = inGroup
        order = inOrder
    }
//    func setGuess(_ num: Int){
//        guess = num
//    }
    func getGuess() -> String{
        return guess
    }
//    func setGroup(_ groupNum: Int){
//        group = groupNum
//    }
    func getGroup() -> Int{
        return group
    }
//    func setOrder(_ orderNum: Int){
//        order = orderNum
//    }
    func getOrder() -> Int{
        return order
    }
}
