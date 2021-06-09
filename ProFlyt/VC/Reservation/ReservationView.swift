//
//  ReservationView.swift
//  ProFlyt
//
//  Created by Simon Weingand on 8/13/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import Parse
import JTSImageViewController
import MCLScrollViewSlider

class ReservationView: UIView {
    
    @IBOutlet weak var availableSeatsLabel: UILabel!
//    @IBOutlet weak var picCarousel: iCarousel!
    
    @IBOutlet weak var placeHolderImageContainer: UIView!
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var picActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passensersLabel: UILabel!
    
    @IBOutlet weak var departureAirportNameLabel: UILabel!
    @IBOutlet weak var departureCityLabel: UILabel!
    @IBOutlet weak var destinationAirportNameLabel: UILabel!
    @IBOutlet weak var destinationCityLabel: UILabel!
    
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var destinationDateLabel: UILabel!
    @IBOutlet weak var flightTimeLabel: UILabel!
    
    @IBOutlet weak var availableSeatsForSaleLabel: UILabel!
    @IBOutlet weak var pricePerSeatLabel: UILabel!
    
    @IBOutlet weak var permissionCheckbox: UIButton!
    @IBOutlet weak var permissionLabel: UILabel!
    
    @IBOutlet weak var amenitiesTextView: UITextView!
    
    @IBOutlet weak var luggageRestrictionsLabel: UILabel!
    
    let bookInfo: BookModel = BookModel.bookInfo
    var images: [UIImage] = [UIImage]()
    var parentViewController: UIViewController!
    
    var pageScrollView: MCLScrollViewSlider!
    var pageClickCallback: MCLClickedCallbackBlock!
    
    var currentPageIndex : Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(viewController: UIViewController!) {
        self.parentViewController = viewController
//        picCarousel.type = iCarouselType.Rotary
        let tapGesture = UITapGestureRecognizer(target: self, action: "setPermission:")
        permissionLabel.addGestureRecognizer(tapGesture)
        
        displayBookInfo()
    }
    
    func displayBookInfo() {
        let aircraftFlight: AircraftFlight = bookInfo.aircraftFlight as! AircraftFlight
        
        let availableSeatNumber = aircraftFlight.charterOperator![kCharterOperatorSeatsAvailable] as! Int
        availableSeatsLabel.text = "Piper Seneca \(availableSeatNumber) Seats"
        
        passensersLabel.text = "\(bookInfo.passenserNumber) passengers"
        
        departureAirportNameLabel.text = bookInfo.departureAirport!["icao"] as? String
        destinationAirportNameLabel.text = bookInfo.destinationAirport!["icao"] as? String
        departureCityLabel.text = bookInfo.departureAirport!["cityState"] as? String
        destinationCityLabel.text = bookInfo.destinationAirport!["cityState"] as? String
        
        let df = NSDateFormatter()
        df.dateFormat = "h:mm a"
        departureTimeLabel.text = df.stringFromDate(aircraftFlight.departureDateTime!)
        destinationTimeLabel.text = df.stringFromDate(aircraftFlight.destinationDateTime!)
        
        df.dateFormat = "dd MMM, yyyy"
        departureDateLabel.text = df.stringFromDate(aircraftFlight.departureDateTime!)
        destinationDateLabel.text = df.stringFromDate(aircraftFlight.destinationDateTime!)
        
        flightTimeLabel.text = aircraftFlight.blockTimeString
        
        let width = UIScreen.mainScreen().bounds.width
        let remainedSeatNumber = availableSeatNumber - bookInfo.passenserNumber
        if remainedSeatNumber > 0
        {
            availableSeatsForSaleLabel.text = "\(remainedSeatNumber) Seats available for sale"
            let price = Int(aircraftFlight.totalPrice / Double(bookInfo.passenserNumber))
            pricePerSeatLabel.text = "could be as low as $" + commaNumber(Double(price)) + "/seat"
            self.frame = CGRectMake(0, 0, width, 630)
        }
        else
        {
            availableSeatsForSaleLabel.hidden = true
            pricePerSeatLabel.hidden = true
            permissionCheckbox.hidden = true
            permissionLabel.hidden = true
            self.frame = CGRectMake(0, 0, width, 540)
        }
        let luggageRestrictions = NSString(format: "%.2f", aircraftFlight.luggageRestrictions)
        
        self.luggageRestrictionsLabel.text = "Luggage Restrictions: \(commaNumber(luggageRestrictions.doubleValue)) lbs"
        
        AirportManager.downloadImage(aircraftFlight.charterOperator![kCharterOperatorPicture] as? PFFile, block: { (image: UIImage?, error: NSError?) -> Void in
            if image != nil
            {
                self.placeHolderImage.image = image
            }
            else
            {
                self.placeHolderImage.image = UIImage(named: "airplain")
            }
        })
        
        self.amenitiesTextView.text = ""
        self.picActivityIndicator.startAnimating()
        
        let aircraftName = aircraftFlight.charterOperator![kAircraftName] as! String
        AirportManager.getAircraft(aircraftName, block: { (result: AnyObject?, error: NSError?) -> Void in
            self.picActivityIndicator.stopAnimating()
            self.picActivityIndicator.hidden = true
            if error == nil && result != nil
            {
                let amenities: String! = result![kAircraftAmentities] as! String
                self.amenitiesTextView.text = (amenities == nil) ? "" : amenities
                for i in 1...5
                {
                    AirportManager.downloadImage(result!["picture\(i)"] as! PFFile!, block: { (image: UIImage?, error: NSError?) -> Void in
                        if image != nil
                        {
                            self.placeHolderImageContainer.hidden = true
                            self.images.append(image!)
//                            self.picCarousel.reloadData()
                            self.showSlideImage()
                        }
                    })
                }
            }
        })
    }
    
    func showSlideImage(){
        if pageScrollView != nil {
            pageScrollView.removeFromSuperview()
        }
        pageScrollView = MCLScrollViewSlider(frame: CGRectMake(0, 28, self.bounds.width, self.bounds.width * 0.6), images: self.images)
        pageScrollView.pageControlAliment = MCLScrollViewSliderPageContolAlimentCenter
        pageScrollView.pageControlCurrentIndicatorTintColor = UIColor.whiteColor()
        pageScrollView.pageControlIndicatorTintColor = UIColor.grayColor()
        pageScrollView.autoScrollTimeInterval = 3600
        self.addSubview(pageScrollView)
        
        pageScrollView.didSelectItemWithBlock { (clickedIndex: Int) -> Void in
            print(clickedIndex)
//            let imageInfo = JTSImageInfo()
//            imageInfo.image = self.images[clickedIndex]
//            _ = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
//            imageViewer.showFromViewController(self.parentViewController, transition: JTSImageViewControllerTransition._FromOriginalPosition)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func setPermission(sender: AnyObject) {
        permissionCheckbox.selected = !permissionCheckbox.selected
    }

    func commaNumber(number: Double) -> String{
        
        let beforeNumber = number
        var resultNumber: String = String()
        var numberInt: Int = Int()
        if beforeNumber % 1000 >= 100
        {
            resultNumber = NSString(format: "%.2f", beforeNumber % 1000) as String
        }
        else if beforeNumber % 1000 >= 10
        {
            resultNumber = "0" + (NSString(format: "%.2f", beforeNumber % 1000) as String) as String
        }
        else if beforeNumber % 1000 >= 0
        {
            resultNumber = "00" + (NSString(format: "%.2f", beforeNumber % 1000) as String) as String
        }
        numberInt = Int(beforeNumber - beforeNumber % 1000)
        if numberInt / 1000 > 0
        {
            while (numberInt / 1000 > 0)
            {
                if Int(numberInt / 1000) < 1000
                {
                    resultNumber = String(Int(numberInt / 1000)) + "," + resultNumber
                    numberInt = Int(numberInt / 1000)
                }
                else
                {
                    numberInt = Int(numberInt / 1000)
                    if Int(numberInt % 1000) >= 100
                    {
                        resultNumber = String(Int(numberInt % 1000)) + "," + resultNumber
                    }
                    else if Int(numberInt % 1000) >= 10
                    {
                        resultNumber = "0" + String(Int(numberInt % 1000)) + "," + resultNumber
                    }
                    else if Int(numberInt % 1000) >= 0
                    {
                        resultNumber = "00" + String(Int(numberInt % 1000)) + "," + resultNumber
                    }
                }
            }
            
        }
        else
        {
            return resultNumber
        }
        return resultNumber
    }
}
