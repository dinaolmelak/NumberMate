//
//  FormViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // When lets go is tapped
    // 1. create a collection(players) in the db
    // 2. create a document in players containing nametext, numberText, isOnline: true and opponent: nil
    // pass document to myDocument to players VC
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
