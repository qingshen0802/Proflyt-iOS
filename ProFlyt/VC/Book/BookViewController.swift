//
//  BookViewController.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/11/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import Alamofire
import SWRevealViewController
import HNKGooglePlacesAutocomplete

class BookViewController: UIViewController, CustomNavigationViewDelegate, RadioButtonDelegate, CustomTextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var navigationView: CustomNavigationView!
    
    @IBOutlet weak var passengerNumberPicker: CustomTextField!
    @IBOutlet weak var departurePlaceTextField: CustomTextField!
    @IBOutlet weak var destinationPlaceTextField: CustomTextField!
    
    
    @IBOutlet weak var specificDepartureTime: RadioButton!
    @IBOutlet weak var specificArrivalTime: RadioButton!
    @IBOutlet weak var departureTimeWindow: RadioButton!
    
    @IBOutlet weak var departureDateAndTimeTextField: CustomTextField!
    @IBOutlet weak var departureDateAndTimeLabel: UILabel!
    @IBOutlet weak var departureDateAndTimeButton: UIButton!
    
    @IBOutlet weak var destinationDateAndTimeLabel: UILabel!
    @IBOutlet weak var destinationDateAndTimeTextField: CustomTextField!
    @IBOutlet weak var destinationDateAndTimeButton: UIButton!
    
    
//    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var addDestination: RadioButton!
    @IBOutlet weak var sameDayReturn: RadioButton!
    @IBOutlet weak var nextDayReturn: RadioButton!
    @IBOutlet weak var returnAnotherDay: RadioButton!
    @IBOutlet weak var itineraryComplete: RadioButton!
    
    let bookInfo: BookModel = BookModel.bookInfo

//    var gpaViewController = GooglePlacesAutocomplete(
//        apiKey: GoogleBroswerApiKey,
//        placeType: .Cities
//    )
    
    var currentAutoCompleteTextField: CustomTextField!
    var isDepartureTextField: Bool!
    var menuViewController: SWRevealViewController!
    
    var placeTableView: UITableView!
    var placeSearchQuery:HNKGooglePlacesAutocompleteQuery!
    var placeSearchResult: [AnyObject] = [AnyObject]()
    var tableViewRect: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookInfo.passenserNumber = 1
        
//        passenserCarousel.type = iCarouselType.CoverFlow
        passengerNumberPicker.setTextFieldType(.Number)
        passengerNumberPicker.mDelegate = self
        
        departurePlaceTextField.mDelegate = self
        destinationPlaceTextField.mDelegate = self
        
        departureDateAndTimeTextField.setTextFieldType(.DateAndTime)
        destinationDateAndTimeTextField.setTextFieldType(.DateAndTime)
        destinationDateAndTimeTextField.setMinimumDateAndTime(NSDate().dateByAddingTimeInterval(10.0 * 60.0))
        departureDateAndTimeTextField.mDelegate = self
        destinationDateAndTimeTextField.mDelegate = self
        
        didSelectRadioButton(tagDepartureTimeWindow, title: "")
        didSelectRadioButton(tagItineraryComplete, title: "")
        
//        gpaViewController.placeDelegate = self
        passengerNumberPicker.text = "1"
        passengerNumberPicker.numberIndex = 0
        
        menuViewController = self.revealViewController()
        if (menuViewController != nil) {
            let backButtonTap = UITapGestureRecognizer(target: self.revealViewController(), action: "revealToggle:")
            menuButton.addGestureRecognizer(backButtonTap)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        placeSearchQuery = HNKGooglePlacesAutocompleteQuery.sharedQuery()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableViewRect = CGRectMake(self.departurePlaceTextField.frame.origin.x, self.departurePlaceTextField.frame.maxY, self.departurePlaceTextField.frame.size.width, 180)
        tableViewRect = self.view.convertRect(tableViewRect, fromView: self.departurePlaceTextField.superview)
        placeTableView = UITableView(frame: tableViewRect)
        placeTableView.dataSource = self
        placeTableView.delegate = self
        placeTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        placeTableView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        self.view.addSubview(placeTableView)
        self.placeTableView.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func departureChanged(sender: AnyObject) {
        isDepartureTextField = true
        currentAutoCompleteTextField = departurePlaceTextField

        tableViewRect = CGRectMake(self.departurePlaceTextField.frame.origin.x, self.departurePlaceTextField.frame.maxY, self.departurePlaceTextField.frame.size.width, 180)
        tableViewRect = self.view.convertRect(tableViewRect, fromView: self.departurePlaceTextField.superview)
        placeTableView.frame = tableViewRect
        
        let searchText = self.departurePlaceTextField.text
        let temp = NSString(string: searchText!)
        if temp.length > 0{
            self.placeTableView.hidden = false
            self.placeSearchQuery.fetchPlacesForSearchQuery(temp as String, completion: { (places, error) -> Void in
                if error != nil {
                    print(error)
                }else{
                    self.placeSearchResult = places
                    self.placeTableView.reloadData()
                }
            })
        } else {
            self.placeTableView.hidden = true
        }
    }
    
    @IBAction func destinationChanged(sender: AnyObject) {
        isDepartureTextField = false
        currentAutoCompleteTextField = destinationPlaceTextField
        
        tableViewRect = CGRectMake(self.destinationPlaceTextField.frame.origin.x, self.destinationPlaceTextField.frame.maxY, self.destinationPlaceTextField.frame.size.width, 180)
        tableViewRect = self.view.convertRect(tableViewRect, fromView: self.destinationPlaceTextField.superview)
        placeTableView.frame = tableViewRect
        
        let searchText = self.destinationPlaceTextField.text
        let temp = NSString(string: searchText!)
        if temp.length > 0{
            self.placeTableView.hidden = false
            self.placeSearchQuery.fetchPlacesForSearchQuery(temp as String, completion: { (places, error) -> Void in
                if error != nil {
                    print(error)
                }else{
                    self.placeSearchResult = places
                    self.placeTableView.reloadData()
                }
            })
        } else {
            self.placeTableView.hidden = true
        }
    }
    
    // MARK: - CustomNavigationViewDelegate
    func onTouchLeftButton()
    {
//        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onTouchRightButton()
    {
        if checkValidate() == true
        {
            switch bookInfo.timeOption {
            case tagSpecificDepatureTime:
                bookInfo.departureDateAndTime = departureDateAndTimeTextField.datePicker.date
                bookInfo.destinationDateAndTime = nil
            case tagSpecificArrivalTime:
                bookInfo.departureDateAndTime = NSDate().dateByAddingTimeInterval(10.0 * 60.0)
                bookInfo.destinationDateAndTime = destinationDateAndTimeTextField.datePicker.date
            default:
                bookInfo.departureDateAndTime = departureDateAndTimeTextField.datePicker.date
                bookInfo.destinationDateAndTime = destinationDateAndTimeTextField.datePicker.date
            }
            
            bookInfo.passenserNumber = passengerNumberPicker.numberIndex + 1
            print("Passeners: \(bookInfo.passenserNumber)")
            self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("airportViewController") as! AirportViewController, animated:
                true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func setDepartureDateAndTime(sender: AnyObject) {
        departureDateAndTimeTextField.becomeFirstResponder()
    }
    
    @IBAction func setDestinationDateAndTime(sender: AnyObject) {
        destinationDateAndTimeTextField.becomeFirstResponder()
    }
    
    // MARK: - CustomTextFieldDelegate
    func textFieldDidEndEditing(sender: AnyObject) {
        let textField = sender as! CustomTextField
//        if textField == departurePlaceTextField
//        {
//            isDepartureTextField = true
//            currentAutoCompleteTextField = departurePlaceTextField
////            presentViewController(gpaViewController, animated: true, completion: nil)
//        }
//        else if textField == destinationPlaceTextField
//        {
//            isDepartureTextField = false
//            currentAutoCompleteTextField = destinationPlaceTextField
////            presentViewController(gpaViewController, animated: true, completion: nil)
//        }
//        else if textField == departureDateAndTimeTextField
        if textField == departureDateAndTimeTextField
        {
            if destinationDateAndTimeTextField.datePicker.date.timeIntervalSinceDate(departureDateAndTimeTextField.datePicker.date) <= 0
            {
                destinationDateAndTimeTextField.setMinimumDateAndTime(departureDateAndTimeTextField.datePicker.date.dateByAddingTimeInterval(10.0 * 60.0))
            }
        }
        else if textField == destinationDateAndTimeTextField
        {
        }
        else if textField == passengerNumberPicker
        {
        }
    }
    
    func alertPlaceName() {
        let alertView = UIAlertController(title: "WARNING!", message: "Departure and destination airport name should be defferent.", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    // MARK: - GooglePlacesAutoCompleteDelegate
    
//    func placeSelected(place: Place) {
//        if isDepartureTextField == true
//        {
//            if place.description == destinationPlaceTextField.text
//            {
//                departurePlaceTextField.text = ""
//                alertPlaceName()
//                return
//            }
//        }
//        else
//        {
//            if place.description == departurePlaceTextField.text
//            {
//                destinationPlaceTextField.text = ""
//                alertPlaceName()
//                return
//            }
//        }
//        place.getDetails(setPlaceDetails)
//        currentAutoCompleteTextField.text = place.description
//        currentAutoCompleteTextField.setValid(true)
//        if isDepartureTextField == true
//        {
//            bookInfo.departurePlaceName = place.description
//        }
//        else
//        {
//            bookInfo.destinationPlaceName = place.description
//        }
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
    func setPlaceDetails(placeDetails: HNKGooglePlacesAutocompletePlace!) {
        if placeDetails == nil
        {
            currentAutoCompleteTextField.text = ""
        }
        else if isDepartureTextField == true
        {
            bookInfo.departurePlaceDetails = placeDetails
            print(placeDetails)
        }
        else
        {
            bookInfo.destinationPlaceDetails = placeDetails
        }
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion:nil)
    }
    
    // MARK: - RadioButtonDelegate
    func didSelectRadioButton(identifier: Int, title: String) {
        self.view.endEditing(true)
        
        if identifier < tagAddDestination
        {
            setTimeOption(identifier)
        }
        else
        {
            setCompleteOption(identifier)
        }
    }
    
    func setTimeOption(identifier: Int) {
        var departure: Bool
        var destination: Bool
        switch identifier {
        case tagSpecificDepatureTime:
            departure = true
            destination = false
        case tagSpecificArrivalTime:
            departure = false
            destination = true
        default:
            departure = true
            destination = true
        }
        if departure == true
        {
            departureDateAndTimeLabel.alpha = 1.0
            departureDateAndTimeTextField.enabled = true
            departureDateAndTimeTextField.setValid(true)
            departureDateAndTimeTextField.datePickerValueChanged(nil)
            departureDateAndTimeTextField.alpha = 1.0
            departureDateAndTimeButton.enabled = true
        }
        else {
            departureDateAndTimeLabel.alpha = 0.5
            departureDateAndTimeTextField.enabled = false
            departureDateAndTimeTextField.setValid(true)
            departureDateAndTimeTextField.datePickerValueChanged(nil)
            departureDateAndTimeTextField.alpha = 0.5
            departureDateAndTimeButton.enabled = false
        }
        
        if destination == true
        {
            destinationDateAndTimeLabel.alpha = 1.0
            destinationDateAndTimeTextField.enabled = true
            destinationDateAndTimeTextField.setValid(true)
            destinationDateAndTimeTextField.datePickerValueChanged(nil)
            destinationDateAndTimeTextField.alpha = 1.0
            destinationDateAndTimeButton.enabled = true
        }
        else {
            destinationDateAndTimeLabel.alpha = 0.5
            destinationDateAndTimeTextField.enabled = false
            destinationDateAndTimeTextField.setValid(true)
            destinationDateAndTimeTextField.datePickerValueChanged(nil)
            destinationDateAndTimeTextField.alpha = 0.5
            destinationDateAndTimeButton.enabled = false
        }
        bookInfo.timeOption = identifier
        for index in tagSpecificDepatureTime...tagDepartureTimeWindow
        {
            if let option = view.viewWithTag(index) as? RadioButton {
                if identifier != index
                {
                    option.selected = false
                }
                else
                {
                    option.selected = true
                }
            }
        }
    }
    
    func setCompleteOption(identifier: Int) {
        bookInfo.completeOption = identifier
        for index in tagAddDestination...tagItineraryComplete {
            if let option = view.viewWithTag(index) as? RadioButton {
                if identifier != index
                {
                    option.selected = false
                }
                else
                {
                    option.selected = true
                }
            }
        }
    }
    
    func checkValidate() -> Bool {
        var isValid = true
        
        if departurePlaceTextField.checkValid() == false
        {
            isValid = false
        }
        
        if destinationPlaceTextField.checkValid() == false
        {
            isValid = false
        }
        
        if (bookInfo.timeOption == tagSpecificDepatureTime || bookInfo.timeOption == tagDepartureTimeWindow) && departureDateAndTimeTextField.checkValid() == false
        {
            isValid = false
        }
        
        if (bookInfo.timeOption == tagSpecificArrivalTime || bookInfo.timeOption == tagDepartureTimeWindow) && destinationDateAndTimeTextField.checkValid() == false
        {
            isValid = false
        }
        
        if bookInfo.departurePlaceDetails == nil
        {
            isValid = false
            departurePlaceTextField.text = ""
            departurePlaceTextField.setValid(false)
        }
        
        if bookInfo.destinationPlaceDetails == nil
        {
            isValid = false
            destinationPlaceTextField.text = ""
            destinationPlaceTextField.setValid(false)
        }
        return isValid
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeSearchResult.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let place: HNKGooglePlacesAutocompletePlace = self.placeSearchResult[indexPath.row] as! HNKGooglePlacesAutocompletePlace
        cell.textLabel?.text = place.name
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPlace: HNKGooglePlacesAutocompletePlace = self.placeSearchResult[indexPath.row] as! HNKGooglePlacesAutocompletePlace
        currentAutoCompleteTextField.text = selectedPlace.name
        print(selectedPlace.placeId)
        CLPlacemark.hnk_placemarkFromGooglePlace(selectedPlace, apiKey: GoogleBroswerApiKey) { (placeMark, address, error) -> Void in
            if placeMark != nil {
                print("Latitude: \(placeMark.location!.coordinate.latitude)  Longitude: \(placeMark.location!.coordinate.longitude)")
            }
        }
        self.placeTableView.hidden = true
        
        if isDepartureTextField == true {
            if selectedPlace.name == destinationPlaceTextField.text
            {
                departurePlaceTextField.text = ""
                alertPlaceName()
                return
            }
        } else {
            if selectedPlace.name == departurePlaceTextField.text
            {
                destinationPlaceTextField.text = ""
                alertPlaceName()
                return
            }
        }
        if isDepartureTextField == true {
            bookInfo.departurePlaceName = selectedPlace.name
        } else {
            bookInfo.destinationPlaceName = selectedPlace.name
        }
        setPlaceDetails(selectedPlace)
    }
}
