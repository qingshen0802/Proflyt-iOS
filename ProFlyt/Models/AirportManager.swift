//
//  AirportManager.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/18/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import Parse

typealias AirportsResultBlock = ([AnyObject]?, NSError?, Double?, Double?, Double?, Double?) -> Void
typealias CharterOperatorResultBlock = ([AnyObject]?, NSError?) -> Void
typealias AirportFuelPriceReulstBlock = (AnyObject?, NSError?) -> Void
typealias AircraftResultBlock = (AnyObject?, NSError?) -> Void
typealias ImageResultBlock = (UIImage?, NSError?) -> Void

class AirportManager: NSObject {
    
    //Get all airports between two airports
    static func getAirportsWithCity(city: String!, northeastLat: Double!, northeastLng: Double!, southwestLat: Double!, southwestLng: Double, block: AirportsResultBlock?) {
        let query = PFQuery(className: kAirportsClassName)
        if city != nil
        {
            query.whereKey(kAirportsCityKey, equalTo: city)
        }
        
        let minLat = min(northeastLat, southwestLat)
        let maxLat = max(northeastLat, southwestLat)
        let minLng = min(northeastLng, southwestLng)
        let maxLng = max(northeastLng, southwestLng)
        query.whereKey(kAirportsLatitudeKey, greaterThanOrEqualTo: minLat)
        query.whereKey(kAirportsLatitudeKey, lessThanOrEqualTo: maxLat)
        query.whereKey(kAirportsLongitudeKey, greaterThanOrEqualTo: minLng)
        query.whereKey(kAirportsLongitudeKey, lessThanOrEqualTo: maxLng)
        
        query.findObjectsInBackgroundWithBlock{ (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if results?.count == 0{
                    AirportManager.getAirportsWithCity(nil, northeastLat: maxLat + 0.01, northeastLng: maxLng + 0.01, southwestLat: minLat - 0.01, southwestLng: minLng - 0.01, block: block)
                } else{
                    block!(results, error, minLat, minLng, maxLat, maxLng)
                }
            } else {
                block!(nil, error, minLat, minLng, maxLat, maxLng)
            }
        }
    }
    
    static func getCharterOperators(iata: String, block: CharterOperatorResultBlock?) {
        let query = PFQuery(className: kCharterOperatorClassName)
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if block != nil {
                block!(results, error)
            }
        }
    }
    
    static func getAirportFuelPrice(iata: String!, block: AirportFuelPriceReulstBlock?) {
        let query = PFQuery(className: kAirportFuelPriceClassName)
//        if iata != nil
//        {
//            query.whereKey(kAirportFuelPriceAirport, equalTo: iata)
//        }
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if block != nil {
                if results != nil && results?.count > 0 {
                    block!(results![0], error)
                } else {
                    block!(nil, error)
                }
            }
        }
    }
    static func getAircraft(name: String!, block: AircraftResultBlock?) {
        let query = PFQuery(className: kAircraftClassName)
        if name != nil {
            query.whereKey(kAircraftName, equalTo: name)
        }
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if block != nil {
                if results != nil && results?.count > 0 {
                    block!(results![0], error)
                } else {
                    block!(nil, error)
                }
            }
        }
    }
    
    static func downloadImage(imageFile: PFFile!, block: ImageResultBlock?) {
        if block != nil
        {
            if imageFile != nil
            {
                imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil
                    {
                        block!(UIImage(data: imageData!), nil)
                    }
                    else
                    {
                        block!(nil, error)
                    }
                })
            }
            else
            {
                block!(nil, nil)
            }
        }
    }
   
}
