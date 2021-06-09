//
//  SearchResultsViewController.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/12/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Parse
import SWRevealViewController

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomNavigationViewDelegate, FlightModelDelegate {

    @IBOutlet weak var navigationView: CustomNavigationView!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var destinationDateLabel: UILabel!
    @IBOutlet weak var departureICAO: UILabel!
    @IBOutlet weak var departureCityLabel: UILabel!
    @IBOutlet weak var destinationICAO: UILabel!
    @IBOutlet weak var destinationCityLabel: UILabel!
    @IBOutlet weak var timeOptionLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var menuButton: UIButton!
    var items : [AnyObject]? = [AnyObject]()
    var aircrafts: [AnyObject]?
    
    let kReusableReservationTableViewCellIdentifier : String = "searchResultsTableViewCell"
    let kReusableLoadinTableViewCellIdentifier : String = "loadingTableViewCell"
    let bookInfo: BookModel = BookModel.bookInfo

    var isLoadedAllAircrafts = false
    var itemCounts: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.rightButton.hidden = true

        displayBookInfo()
        
        loadAircrafts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:
    func displayBookInfo() {
        let df = NSDateFormatter()
        df.dateFormat = "h:mm a"
        departureTimeLabel.text = bookInfo.departureDateAndTime == nil ? "" : df.stringFromDate(bookInfo.departureDateAndTime!)
        destinationTimeLabel.text = bookInfo.destinationDateAndTime == nil ? "" : df.stringFromDate(bookInfo.destinationDateAndTime!)
        
        df.dateFormat = "dd MMM, yyyy"
        departureDateLabel.text = bookInfo.departureDateAndTime == nil ? "" : df.stringFromDate(bookInfo.departureDateAndTime!)
        destinationDateLabel.text = bookInfo.destinationDateAndTime == nil ? "" : df.stringFromDate(bookInfo.destinationDateAndTime!)
        
        departureICAO.text = bookInfo.departureAirport!["icao"] as? String
        destinationICAO.text = bookInfo.destinationAirport!["icao"] as? String
        departureCityLabel.text = bookInfo.departureAirport!["cityState"] as? String
        destinationCityLabel.text = bookInfo.destinationAirport!["cityState"] as? String
        
        switch bookInfo.timeOption {
        case tagSpecificDepatureTime:
            timeOptionLabel.text = "Specific Departure Time"
        case tagSpecificArrivalTime:
            timeOptionLabel.text = "Specific Destination Time"
        default:
            timeOptionLabel.text = "Departure Time Window"
        }
    }
    
    // MARK: - Load Aircrafts
    func loadAircrafts() {
        isLoadedAllAircrafts = false
        messageLabel.hidden = true
        tableView.hidden = false
        
        AirportManager.getCharterOperators("", block: { (results: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil
            {
                if results!.count > 0
                {
                    self.aircrafts = results!
                    self.getWindTempDatas()
                }
                else
                {
                    self.messageLabel.text = "No Results"
                    self.messageLabel.hidden = false
                    self.isLoadedAllAircrafts = true
                    self.tableView.hidden = true
                    self.tableView.reloadData()
                }
            }
            else
            {
                self.messageLabel.text = error?.localizedDescription
                self.messageLabel.hidden = false
                self.isLoadedAllAircrafts = true
                self.tableView.hidden = true
                self.tableView.reloadData()
            }
        })
    }
    
    func getWindTempDatas() {
        let flight: FlightModel = FlightModel()
        flight.mDelegate = self
        if let aircrafts = self.aircrafts
        {
            flight.setData(
                aircrafts as? [PFObject],
                departureAirport: self.bookInfo.departureAirport as? PFObject,
                destinationAirport: self.bookInfo.destinationAirport as? PFObject,
                departureDateTime: self.bookInfo.departureDateAndTime!,
                destinationDateTime: self.bookInfo.destinationDateAndTime == nil ? nil : self.bookInfo.destinationDateAndTime!,
                passengerNumber: self.bookInfo.passenserNumber!)
        }
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numbers = 0
        if items != nil
        {
            numbers = items!.count
        }
        
        if isLoadedAllAircrafts == false
        {
            numbers++
        }
        return numbers
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == items!.count
        {
            let cell = tableView.dequeueReusableCellWithIdentifier(kReusableLoadinTableViewCellIdentifier, forIndexPath: indexPath) 
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(kReusableReservationTableViewCellIdentifier, forIndexPath: indexPath) as! SearchResultsTableViewCell
            cell.setCellData(items![indexPath.row] as? AircraftFlight)

            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.bookInfo.aircraftFlight = items![indexPath.row]
        onTouchRightButton()
    }
    
    // MARK: - CustomNavigationViewDelegate
    func onTouchLeftButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onTouchRightButton() {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("reservationViewController") as! ReservationViewController, animated: true)
    }
    
    // MARK: - FlightModelDelegate
    func addAircraft(aircraftFlight: AircraftFlight?)
    {
        if ++itemCounts == aircrafts?.count
        {
            isLoadedAllAircrafts = true
        }
        
        if aircraftFlight != nil
        {
            items?.append(aircraftFlight!)
//            let indexPath = NSIndexPath(forRow: items!.count - 1, inSection: 0)
//            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        tableView.reloadData()
    }

}
