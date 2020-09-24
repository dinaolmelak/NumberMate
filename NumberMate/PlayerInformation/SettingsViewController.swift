//
//  SettingsViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/24/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var firstLabel: UITextField!
    @IBOutlet weak var lastLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onDone(_ sender: Any) {
        // update account
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onTapDelete(_ sender: Any) {
        // delete account
        
        dismiss(animated: true, completion: nil)
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
