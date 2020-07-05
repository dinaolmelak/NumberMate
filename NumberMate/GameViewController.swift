//
//  GameViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/3/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    // myDocument Ref
    // opponentLabel
    // opponentNumber
    // [guesses]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set opponentLabel from myDocumentRef.opponent Name
        // set oppoenetNumber from myDocumentRef.opponent Number
    }
    
    // for each cells in tableView
    // when tapped add guess
        // check guess group and order against opponentNumber
        // disable the cell and store number in guesses array
        // if group and order of guess == 4
        //      -> display winner alert
        //      -> if name !exists in winners collection
        //          store name in winners collection and numWin = 1
        //      -> else numWin += 1
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
