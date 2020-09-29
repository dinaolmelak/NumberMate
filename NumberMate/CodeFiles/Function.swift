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
    
    func showQuestion(Title title:String, Message message:  String,ViewController vc:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "YES", style: .default, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        vc.present(alert, animated: true)
    }
    func showAlert(Title title:String, Message message:  String,ViewController vc:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(noAction)
        
        vc.present(alert, animated: true)
    }
}
