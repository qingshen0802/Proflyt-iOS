//
//  HomeViewController.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/7/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import SWRevealViewController

class HomeViewController: UIViewController {    
    var menuViewController: SWRevealViewController!
    
    @IBOutlet weak var menuButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuViewController = self.revealViewController()
        if (menuViewController != nil) {
            let menuButtonTapGesture = UITapGestureRecognizer(target: self.revealViewController(), action: "revealToggle:")
            menuButton.addGestureRecognizer(menuButtonTapGesture)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */ 
}
