//
//  MenuViewController.swift
//  ProFlyt
//
//  Created by Simon Weingand on 9/23/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
//    var items : NSMutableArray! = NSMutableArray(objects:
//        ["title": "My Profile", "image":"icon_myprofile"] as NSDictionary,
//        ["title": "Book a Flight", "image":"icon_bookaflight"] as NSDictionary,
//        ["title": "My Flight Status", "image":"icon_myflightstatus"] as NSDictionary,
//        ["title": "Cargo", "image":"icon_cargo"] as NSDictionary,
//        ["title": "Air Ambulance", "image":"icon_airambulance"] as NSDictionary,
//        ["title": "Helicopter", "image":"icon_helicopter"] as NSDictionary,
//        ["title": "About us", "image":"icon_aboutus"] as NSDictionary,
//        ["title": "CJO Portal", "image":"icon_cjoportal"] as NSDictionary)
//    let kReusableHomeTableViewCellIdentifier : String = "menuItemCell"
    
    var menuItemIdentifiers = ["bookAFlight", "myProfile", "myFlightStatus", "cargo", "airAmbulance", "helicopter", "aboutus", "cjoPortal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemIdentifiers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableHomeTableViewCellIdentifier, forIndexPath: indexPath) as! MenuItem
//        cell.titleLabel.text = items[indexPath.row]["title"] as? String
//        cell.maskImageView.image = UIImage(named: items[indexPath.row]["image"] as! String!)
//        if indexPath.row == 0 {
//            cell.setNotify(2)
//        }
        let cell = tableView.dequeueReusableCellWithIdentifier(menuItemIdentifiers[indexPath.row], forIndexPath: indexPath) 
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var indexPath = self.tableView.indexPathForSelectedRow()
    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        if indexPath.row == 1
//        {
//            let bookVC = self.storyboard?.instantiateViewControllerWithIdentifier("bookViewController") as! BookViewController
//            self.navigationController?.pushViewController(bookVC, animated: true)
//        }
//        else if indexPath.row == 2
//        {
//            //let reservationVC = self.storyboard?.instantiateViewControllerWithIdentifier("reservationViewController") as! AirportViewController
//            //self.navigationController?.pushViewController(reservationVC, animated: true)
//        }
//    }
}