//
//  ReservationViewController.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/22/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import SWRevealViewController

class ReservationViewController: UIViewController, CustomNavigationViewDelegate {

    @IBOutlet weak var navigationView: CustomNavigationView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var menuButton: UIButton!
    var reservationView: ReservationView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if reservationView == nil
        {
            reservationView = NSBundle.mainBundle().loadNibNamed("ReservationView", owner: self, options: nil)[0] as! ReservationView
            reservationView.translatesAutoresizingMaskIntoConstraints = true
            self.scrollView.addSubview(reservationView)
            reservationView.initialize(self)
            scrollView.contentSize = CGSizeMake(0, reservationView.bounds.height)
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
    
    // MARK: - CustomNavigationViewDelegate
    func onTouchLeftButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onTouchRightButton() {
        
    }
    
}
