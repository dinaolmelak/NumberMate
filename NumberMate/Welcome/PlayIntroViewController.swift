//
//  PlayIntroViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/22/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import Lottie

class PlayIntroViewController: UIViewController {
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var pictureGif: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pictureGif.loadGif(name: "6552-search")
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.animatingToLeft()
        }
    }
    
    func animatingToLeft(){
        UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [], animations: {
            self.arrowImage.center.x -= 150
        }, completion: nil)
        arrowImage.center.x += 150
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
