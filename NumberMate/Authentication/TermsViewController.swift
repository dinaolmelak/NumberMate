//
//  TermsViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 11/27/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController, WKUIDelegate {
    var termsWebView: WKWebView!
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        termsWebView = WKWebView.init(frame: .zero, configuration: webConfig)
        termsWebView.uiDelegate = self
        view = termsWebView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://ace-destination-282219.web.app/%E2%9C%A6NumberMate%20c97c29fff1cf44d4a9f3a6cbe832b4be/Terms%20and%20Conditions%20ce8e72f08b5e480d883cebeb1b388500.html"
        let nmateUrl = URL(string: url)
                let myRequest = URLRequest(url: nmateUrl!)
                termsWebView.load(myRequest)
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func onBack(_ sender: Any) {
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
