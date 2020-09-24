//
//  WinnersViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 7/4/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class WinnersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPlay(_ sender: Any) {
        performSegue(withIdentifier: "GameSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
