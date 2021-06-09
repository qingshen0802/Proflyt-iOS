//
//  AirportViewController.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/15/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse
import MBProgressHUD
import SWRevealViewController
import HNKGooglePlacesAutocomplete

class AirportViewController: UIViewController, CustomNavigationViewDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
        
    @IBOutlet weak var navigationView: CustomNavigationView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var viewTitle: UILabel!
    
    @IBOutlet weak var airportNameBottomView: UIView!
    @IBOutlet weak var airportNameLabel: UILabel!
    
    @IBOutlet weak var menuButton: UIButton!
//    @IBOutlet weak var arrowUpImageView: UIImageView!
    
    var isDeparture = true
    let bookInfo = BookModel.bookInfo
    
    // Departure Airports Info
    var departureAirports: [AnyObject]!
    var departureNortheastLat: Double!
    var departureNortheastLng: Double!
    var departureSouthwestLat: Double!
    var departureSouthwestLng: Double!
    var selectedDepartureAirportMarker: CustomMarker!
    
    // Destination Airports Info
    var destinationAirports: [AnyObject]!
    var destinationNortheastLat: Double!
    var destinationNortheastLng: Double!
    var destinationSouthwestLat: Double!
    var destinationSouthwestLng: Double!
    var selectedDestinationAirportMarker: CustomMarker!
    
    // Current Place details: 
    // If it is departure,   placeDetails = bookInfo.departurePlaceDetails.
    // If not,               placeDetails = bookInfo.destinationPlaceDetails
    var currentPlaceDetails: HNKGooglePlacesAutocompletePlace!
    var departureLatitude: Double!
    var departureLongitude: Double!
    var destinationLatitude: Double!
    var destinationLongitude: Double!
    
    var currentMarker: GMSMarker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        airportNameBottomView.alpha = 0.0
        airportNameLabel.alpha = 0.0
//        arrowUpImageView.alpha = 0.0
        
        currentPlaceDetails = bookInfo.departurePlaceDetails
        navigationView.rightButton.enabled = false
        updateAllLabels()
        updateCamera()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - CustomNavigationViewDelegate

    func onTouchLeftButton() {
        if isDeparture == false
        {
            isDeparture = true
            currentPlaceDetails = bookInfo.departurePlaceDetails
            updateAllLabels()
            updateCamera()
        }
        else
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func onTouchRightButton() {
        if isDeparture == true
        {
            if selectedDepartureAirportMarker != nil
            {
                bookInfo.departureAirport = selectedDepartureAirportMarker.placeDetails
                isDeparture = false
                navigationView.rightButton.enabled = false
                print(selectedDepartureAirportMarker.placeDetails)
                currentPlaceDetails = bookInfo.destinationPlaceDetails
                updateAllLabels()
                updateCamera()
            }
        }
        else
        {
            if selectedDestinationAirportMarker != nil
            {
                bookInfo.destinationAirport = selectedDestinationAirportMarker.placeDetails
                print(selectedDestinationAirportMarker.placeDetails)
                self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("searchResultsViewController") as! SearchResultsViewController, animated: true)
            }
        }
    }
    
    func updateAllLabels() {
        UIView.animateWithDuration(0.5,
            animations: { () -> Void in
                self.navigationView.titleLabel.alpha = 0.0
                self.placeLabel.alpha = 0.0
                self.airportNameBottomView.alpha = 0.0
//                self.arrowUpImageView.alpha = 0.0
                self.airportNameLabel.alpha = 0.0
        }) { (Bool) -> Void in
            if self.isDeparture == true
            {
                self.navigationView.titleLabel.text = ""
                self.viewTitle.text = "Departure Airport"
                self.placeLabel.text = "Farewell " + self.bookInfo.departurePlaceDetails.name
            }
            else
            {
                self.navigationView.titleLabel.text = ""
                self.viewTitle.text = "Destination Airport"
                self.placeLabel.text = "Welcome To " + self.bookInfo.destinationPlaceDetails.name
            }
            self.displayAirportName()
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.navigationView.titleLabel.alpha = 1.0
                self.placeLabel.alpha = 1.0
                if (self.isDeparture == true && self.selectedDepartureAirportMarker != nil) ||
                    (self.isDeparture == false && self.selectedDestinationAirportMarker != nil)
                {
                    self.airportNameBottomView.alpha = 1.0
                    self.airportNameLabel.alpha = 1.0
//                    self.arrowUpImageView.alpha = 1.0
                }
            })
        }
    }
    
    func updateAirportNameLabel() {
        var hideDuration = 0.5
        if airportNameBottomView.alpha == 0.0
        {
            hideDuration = 0.0
        }
        UIView.animateWithDuration(hideDuration,
            animations: { () -> Void in
                self.airportNameLabel.alpha = 0.0
            }) { (Bool) -> Void in
                self.displayAirportName()
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    if (self.isDeparture == true && self.selectedDepartureAirportMarker != nil) ||
                        (self.isDeparture == false && self.selectedDestinationAirportMarker != nil)
                    {
                        self.airportNameBottomView.alpha = 1.0
                        self.airportNameLabel.alpha = 1.0
//                        self.arrowUpImageView.alpha = 1.0
                    }
                })
        }
        navigationView.rightButton.enabled = true
    }
    
    func displayAirportName() {
        if self.isDeparture == true
        {
            if self.selectedDepartureAirportMarker != nil
            {
                displayAirportName(self.selectedDepartureAirportMarker!.placeDetails as! PFObject)
            }
        }
        else
        {
            if self.selectedDestinationAirportMarker != nil
            {
                displayAirportName(self.selectedDestinationAirportMarker!.placeDetails as! PFObject)
            }
        }
    }
    
    func displayAirportName(placeDetails: PFObject!) {
        self.airportNameLabel.text = (placeDetails!["icao"] as? String)! + " (" + (placeDetails!["name"] as? String)! + ")"
    }
    
    // MARK: - MapView Camera Update
    func updateCamera() {
        addAirportsMarker()
    }
    
    func addAirportsMarker() {
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        
        mapView.clear()
        
        if isDeparture == true
        {
            if selectedDepartureAirportMarker != nil
            {
                navigationView.rightButton.enabled = true
            }
            
            if departureAirports == nil
            {
                getAirport()
            }
            else {
                self.addAirportsMarker(self.departureAirports)
            }
        }
        else
        {
            if selectedDestinationAirportMarker != nil
            {
                navigationView.rightButton.enabled = true
            }
            
            if destinationAirports == nil {
                getAirport()
            }
            else {
                self.addAirportsMarker(self.destinationAirports)
            }
        }
    }
    
    func getAirport() {
        var latitude = 0.0
        var longitude = 0.0
        CLPlacemark.hnk_placemarkFromGooglePlace(currentPlaceDetails, apiKey: GoogleBroswerApiKey) { (placeMark, address, error) -> Void in
            if placeMark != nil {
                print("City Name: \(self.currentPlaceDetails.name)")
                print("Latitude: \(placeMark.location!.coordinate.latitude)  Longitude: \(placeMark.location!.coordinate.longitude)")
                latitude = (placeMark.location?.coordinate.latitude)!
                longitude = (placeMark.location?.coordinate.longitude)!
                
                AirportManager.getAirportsWithCity(self.currentPlaceDetails.name,
                    northeastLat: latitude + 2.5,
                    northeastLng: longitude + 2.5,
                    southwestLat: latitude - 2.5,
                    southwestLng: longitude - 2.5) { (results:[AnyObject]?, error: NSError?, northeastLat: Double?, northeastLng: Double?, southwestLat: Double?, southwestLng: Double?) -> Void in
                        if error != nil
                        {
                            MBProgressHUD.hideAllHUDsForView(self.navigationController?.view, animated: true)
                        }
                        else
                        {
                            if self.isDeparture == true
                            {
                                self.departureAirports = results
                                self.departureNortheastLat = northeastLat
                                self.departureNortheastLng = northeastLng
                                self.departureSouthwestLat = southwestLat
                                self.departureSouthwestLng = southwestLng
                                self.departureLatitude = latitude
                                self.departureLongitude = longitude
                            }
                            else
                            {
                                self.destinationAirports = results
                                self.destinationNortheastLat = northeastLat
                                self.destinationNortheastLng = northeastLng
                                self.destinationSouthwestLat = southwestLat
                                self.destinationSouthwestLng = southwestLng
                                self.destinationLatitude = latitude
                                self.destinationLongitude = longitude
                            }
                            self.addAirportsMarker()
                        }
                }
            }
        }
    }
    
    func addAirportsMarker(airports: [AnyObject]!)
    {
        MBProgressHUD.hideAllHUDsForView(self.navigationController?.view, animated: true)
        var bounds: GMSCoordinateBounds!
        if isDeparture
        {
            bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2DMake(self.departureLatitude - 0.5, self.departureLongitude - 0.5), coordinate: CLLocationCoordinate2DMake(self.departureLatitude + 0.5, self.departureLongitude + 0.5))
        }
        else
        {
            bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2DMake(self.destinationLatitude - 0.5, self.destinationLongitude - 0.5), coordinate: CLLocationCoordinate2DMake(self.destinationLatitude + 0.5, self.destinationLongitude + 0.5))
        }
        var index = 0
        for airport in airports
        {
            let position = CLLocationCoordinate2DMake(airport["latitude"] as! Double, airport["longitude"] as! Double)
            if index <= 3{
                bounds.includingCoordinate(position)
            }
            let marker = CustomMarker(placeDetails: airport as! PFObject)
            
            let objectId = (airport as! PFObject).objectId as String?
            let departureId = (selectedDepartureAirportMarker != nil) ? selectedDepartureAirportMarker!.placeDetails.objectId as String? : ""
            let destinationId = (selectedDestinationAirportMarker != nil) ? selectedDestinationAirportMarker!.placeDetails.objectId as String? : ""
            if objectId == departureId || objectId == destinationId
            {
                marker.icon = UIImage(named: "icon_marker_dark_purple")
                if isDeparture == true
                {
                    selectedDepartureAirportMarker = marker
                }
                else
                {
                    selectedDestinationAirportMarker = marker
                }
            }
            else
            {
                setIconOfMarker(marker)
            }
            marker.map = self.mapView
            index++
        }
        self.mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 0.5))
    }

    // MARK: - GMSMapViewDelegate
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let infoWindow: CustomInfoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil)[0] as! CustomInfoWindow
        let placeDetails: PFObject! = (marker as! CustomMarker).placeDetails as! PFObject
        infoWindow.airportNameLabel.text = placeDetails["name"] as? String //marker.title
        infoWindow.cityStateLabel.text = placeDetails["cityState"] as? String//marker.snippet
        infoWindow.airportICAO.text = "ICAO: " + (placeDetails["icao"] as? String)!
        
        if isDeparture  == true
        {
            infoWindow.chooseButton.setTitle("Set Departure Airport", forState: .Normal)
        }
        else
        {
            infoWindow.chooseButton.setTitle("Set Destination Airport", forState: .Normal)
        }
        
        return infoWindow
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        let selectedMarker = marker as! CustomMarker
        
        if isDeparture == true
        {
            if selectedDepartureAirportMarker != nil
            {
                setIconOfMarker(selectedDepartureAirportMarker)
            }
            selectedDepartureAirportMarker = selectedMarker
        }
        else
        {
            if selectedDestinationAirportMarker != nil
            {
                setIconOfMarker(selectedDestinationAirportMarker)
            }
            selectedDestinationAirportMarker = selectedMarker
        }
        selectedMarker.icon = UIImage(named: "icon_marker_dark_purple")
        mapView.selectedMarker = nil
        updateAirportNameLabel()
    }
    
    func setIconOfMarker(marker: CustomMarker) {
        let city = marker.placeDetails!["city"] as! String
        if (self.currentPlaceDetails.name as String) == city
        {
            marker.icon = UIImage(named: "icon_marker_purple")
        }
        else {
            marker.icon = UIImage(named: "icon_marker_pink")
        }
    }
}
