//
//  BookModel.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/17/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import HNKGooglePlacesAutocomplete

class BookModel {
    
    //Deparature place name
    var departurePlaceName: String!
    //Destination Place name
    var destinationPlaceName: String!
    
    //Deparature and destination places detail info
    var departurePlaceDetails: HNKGooglePlacesAutocompletePlace!
    var destinationPlaceDetails: HNKGooglePlacesAutocompletePlace!
    
    //Deparature and destination date and time
    var departureDateAndTime: NSDate?
    var destinationDateAndTime: NSDate?
    
    var timeOption: Int!//time option(specific deparature, destination, both of them
    var completeOption: Int!//same, next, other day return
    var passenserNumber: Int!
    
    //Airports
    var departureAirport: AnyObject!
    var destinationAirport: AnyObject!
    //Aircraft
    var aircraftFlight: AnyObject!
    //singleton bookmodel for whole project
    static let bookInfo: BookModel = BookModel()
}
