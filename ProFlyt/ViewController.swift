//
//  ViewController.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/7/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isLoggedIn = defaults.boolForKey(kConfirmLoggedIn) as Bool?
        {
            if isLoggedIn == true
            {
                self.performSegueWithIdentifier(siGotoHome, sender: self)
            }
            else
            {
                self.performSegueWithIdentifier(siGotoLogin, sender: self)
            }
            
        }
        else {
            self.performSegueWithIdentifier(siGotoLogin, sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }			
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        super.prepareForSegue(segue, sender: sender)
    }

}

