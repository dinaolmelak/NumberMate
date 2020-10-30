//
//  PointsIntroViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/22/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class PointsIntroViewController: UIViewController {

    @IBOutlet weak var gifPicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gifPicture.loadGif(name: "18880-watch-videos")
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
