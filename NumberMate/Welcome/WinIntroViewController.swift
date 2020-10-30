//
//  WinIntroViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/22/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit


class WinIntroViewController: UIViewController {

    @IBOutlet weak var gifPicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gifPicture.loadGif(name: "4768-trophy")
    }
    

    @IBAction func didTapGo(_ sender: Any) {
        performSegue(withIdentifier: "StartSegue", sender: self)
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
