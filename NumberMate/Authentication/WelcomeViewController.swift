//
//  WelcomeViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 10/30/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "IntroPageViewController") as IntroPageViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
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
