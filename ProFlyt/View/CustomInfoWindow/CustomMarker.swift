//
//  CustomMarker.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/20/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import GoogleMaps

class CustomMarker: GMSMarker {
    var placeDetails: AnyObject!
    
    init(placeDetails: AnyObject!) {
        self.placeDetails = placeDetails
        super.init()
        self.position = CLLocationCoordinate2DMake(placeDetails["latitude"] as! Double, placeDetails["longitude"] as! Double)
        self.groundAnchor = CGPoint(x: 0.4, y: 1)
        appearAnimation = kGMSMarkerAnimationPop
        self.title = placeDetails["name"] as! String
        self.snippet = placeDetails["cityState"] as! String
    }
}
