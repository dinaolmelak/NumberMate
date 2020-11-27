//
//  HelpViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 11/24/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var helpImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpImage.loadGif(name: "5306-rocket-funk")
        helpView.layer.cornerRadius = 20
        helpView.layer.shadowRadius = 5
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.helpView.center.y = self.helpView.center.y + 200
    }
    override func viewDidAppear(_ animated: Bool) {
        //animateDown()
    }
    
    func animateDown()
    {
        UIView.animate(withDuration: 1.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: [], animations: {
            self.helpView.center.y += 200
        }, completion: nil)
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
