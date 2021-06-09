//
//  LoginViewController.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/7/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isLoggedIn = defaults.boolForKey(kConfirmLoggedIn) as Bool?
        {
            if isLoggedIn == true
            {
                self.performSegueWithIdentifier(siGotoHome, sender: self)
                return;
            }
        }
        showLoginView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    
    // MARK: - show LoginView
    func showLoginView() {
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.blurImage(self.backgroundImageView)
            self.showAndAnimationView(self.loginView)
        }
    }
    
    // MARK: - Blur Image View
    func blurImage(imageView: UIImageView?) {
        if imageView != nil {
            let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame = imageView!.bounds;
            blurView.alpha = 0.0
            imageView?.addSubview(blurView)
            
            showAndAnimationView(blurView)
        }
    }
    
    // MARK: - show and animation view
    func showAndAnimationView(view: UIView?) {
        if view != nil {
            
            view?.alpha = 0.0
            view?.hidden = false
            
            UIView.animateWithDuration(1.5,
                animations: { () -> Void in
                    view?.alpha = 1.0
                },
                completion: { (Bool) -> Void in
                    
                }
            );
        }
    }

}
