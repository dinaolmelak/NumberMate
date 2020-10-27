//
//  Function.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/29/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import Foundation
import UIKit

class Function {
    func isRepeated(_ inString: String)->Bool{
        var num = 0
        for i in inString {
            for x in inString{
                if i == x{
                    num += 1
                }
            }
        }
        if num == 4{
            return false//their is no number repeating
        }else{
            return true
        }
        //return true
    }
    func checkGroup(guessNum: String, hiddenNum: String) -> Int{
        var counter = 0;
        
        for i in guessNum{
            for x in hiddenNum{
                if i == x{
                    counter += 1
                }
            }
        }
        
        return counter
    }
    func checkOrder(guessNum: String, hiddenNum: String) -> Int{
        var counter = 0
        var myIndex = 0
        var uIndex = 0
        for i in guessNum{
            for x in hiddenNum{
                if i == x && myIndex == uIndex{
                    counter += 1
                }
                uIndex += 1
            }
            myIndex += 1
            uIndex = 0
        }
        
        return counter
    }
    
    func playingNumberGenerator()->Int{
        let digits = 0...9
        // Shuffle them
        let shuffledDigits = digits.shuffled()

         // Take the number of digits you would like
        let fourDigits = shuffledDigits.prefix(4)

         // Add them up with place values
        var value = fourDigits.reduce(0) {
             $0*10 + $1
        }
        if (value < 1000){
            value = playingNumberGenerator()
        }
        return value
    }
    
    func batchIDGenerator()->Int{
        let digits = 0...9
        // Shuffle them
        let shuffledDigits = digits.shuffled()

         // Take the number of digits you would like
        let fourDigits = shuffledDigits.prefix(10)

         // Add them up with place values
        let value = fourDigits.reduce(0) {
             $0*10 + $1
        }
        
        return value
    }
    
    func showAlert(Title title:String, Message message:  String,ViewController vc:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(noAction)
        
        vc.present(alert, animated: true)
    }
}
