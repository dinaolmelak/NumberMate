//
//  IntroPageViewController.swift
//  NumberMate
//
//  Created by Dinaol Melak on 9/22/20.
//  Copyright © 2020 Dinaol Melak. All rights reserved.
//

import UIKit

class IntroPageViewController: UIPageViewController, UIPageViewControllerDataSource{
    
    var myControllers = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        // Do any additional setup after loading the view.
        addingViewControllers()
        if let firstVC = myControllers.first{
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "isUser") == false{
            print("yes")
            //            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            //            //modalPresentationStyle
            //            vc.modalPresentationStyle = .fullScreen
            //            present(vc, animated: true, completion: nil)
        } else{
            performSegue(withIdentifier: "SkipIntroSegue", sender: self)
            print("not First time")
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = myControllers.firstIndex(of: viewController), vcIndex > 0 else {
            return nil
        }
        let before = vcIndex -  1
        return myControllers[before]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = myControllers.firstIndex(of: viewController), vcIndex < (myControllers.count - 1) else{
            return nil
        }
        let after = vcIndex + 1
        
        return myControllers[after]
    }
    func addingViewControllers(){
        let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GettingStartedViewController")
        let playVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayIntroViewController") as UIViewController
        let pointsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PointsIntroViewController") as UIViewController
        let winVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WinIntroViewController") as UIViewController
        myControllers.append(welcomeVC)
        myControllers.append(playVC)
        myControllers.append(pointsVC)
        myControllers.append(winVC)
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
