//
//  ProFlytConstants.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/7/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

// MARK: testing
let IS_TESTING = false

// MARK: - Google API Key
let GoogleiOSApiKey = "AIzaSyDHmPP1EkOGXFtPHQ3W2yl8zqhBWgvjwtQ"
let GoogleBroswerApiKey = "AIzaSyCxj2WOhDV69Dq4uKcd2oDAMLzPd9-woDc"

// MARK: - Parse.com
let ParseApplicationId = "hCsWXurPKCGQpSlhJi3FtmAKWenpOYiJbXZJc25f"
let ParseClientKey = "rI5RPVycZyXfSuPzv2pROKUKzWcTzgCk2CxhhbPp"

// MARK: - NSUserDefaults
let kConfirmLoggedIn = "isLoggedIn"

// Mark: - Segues
let siGotoLogin = "gotoLoginVC"
let siGotoSignup = "gotoSignupVC"
let siGotoHome = "gotoHomeNav"

// MARK: - Identifier Tags
let tagSpecificDepatureTime = 1001
let tagSpecificArrivalTime = 1002
let tagDepartureTimeWindow = 1003

let tagAddDestination = 1101
let tagSameDayReturn = 1102
let tagNextDayReturn = 1103
let tagReturnAnotherDay = 1104
let tagItineraryComplete = 1105


// MARK: - Parse: Airports Class
// Class Name
let kAirportsClassName = "AirportsICAO"
// columns
let kAirportsObjectIdKey = "objectId"
let kAirportsCityKey = "city"
let kAirportsCityStateKey = "cityState"
let kAirportsCountryCodeKey = "countryCode"
let kAirportsElevationKey = "elevation"
let kAirportsIATAKey = "iata"
let kAirportsICAOKey = "icao"
let kAirportsLatitudeKey = "latitude"
let kAirportsLongitudeKey = "longitude"
let kAirportsNameKey = "name"
let kAirportsStateKey = "state"
let kAirportsTimezoneKey = "timezone"
let kAirportsCreatedAtKey = "createdAt"
let kAirportsUpdatedAtKey = "updatedAt"

// MARK: - Parse: CharterOperator Class
// Class Name
let kCharterOperatorClassName = "CharterOperator"
// columns
let kCharterOperatorName = "name"
let kCharterOperatorModel = "mode"
let kCharterOperatorTailNumber = "tailNumber"
let kCharterOperator = "charterOperator"
let kCharterOperatorPicture = "picture"
let kCharterOperatorCategory = "category"
let kCharterOperatorSeatsAvailable = "seatsAvailable"
let kCharterOperatorPricePerHour = "pricePerHour"
let kCharterOperatorCruisKTAS = "cruiseKTAS"                            // KTAS = Knots True AirSpeed
let kCharterOperatorPreferredCruiseAltitude = "preferredCruiseAltitude"
let kCharterOperatorMaxFuelCapacityLBS = "maxFuelCapacityLBS"           // LBS = Pounds
let kCharterOperatorBurnRatePPH = "burnRatePPH"                         // PPH = LBS Per Hour
let kCharterOperatorSTTO = "stto"
let kCharterOperatorMaxTOWeightLBS = "maxTOWeightLBS"
let kCharterOperatorEmptyWeightLBS = "emptyWeightLBS"
let kCharterOperatorUsefulLoad = "usefulLoad"
let kCharterOperatorCrewComposition = "crewComposition"
let kCharterOperatorMinRunwayLength = "minRunwayLength"

// MARK: Parse: AirportFuelPrice Class
// Class Name
let kAirportFuelPriceClassName = "AirportFuelPrice"
// columns
let kAirportFuelPriceAirport = "airport"
let kAirportFuelPriceCurrency = "currency"
let kAirportFuelPriceFacilityId = "facilityId"
let kAirportFuelPriceName = "name"
let kAirportFuelPricePhoneMain = "phoneMain"
let kAirportFuelPrice100llFS = "price100llfs"
let kAirportFuelPrice100llss = "price100llss"
let kAirportFuelPriceJetaPrist = "priceJetaPrist"
let kAirportFuelPriceJetafs = "priceJetafs"
let kAirportFuelPriceTime = "time"
let kAirportFuelPriceUnits = "units"
// MARK: Parse: Aircraft Class
// Class Name
let kAircraftClassName = "Aircrafts"
// columns
let kAircraftName = "name"
let kAircraftAmentities = "amentities"
let kAircraftPicture = "picture"
let kAircraftPicture1 = "picture1"
let kAircraftPicture2 = "picture2"
let kAircraftPicture3 = "picture3"
let kAircraftPicture4 = "picture4"
let kAircraftPicture5 = "picture5"

//Wind Aloft Data

let wSTART_LAT = 70.0
let wEND_LAT = 20.0
let wEND_LONG = -45.0
let wSTART_LONG = -175.0
let wDELTA = 2.5
let wNUM_LAT = 21
let wNUM_LONG = 53

//These value array contains all altitudes for wind data file
let fts: [Int] = [8000, 10000, 15000, 18000, 21000, 24000, 27000, 30000, 33000, 36000, 39000, 42000]

class ProFlytConstants: NSObject {
   
}
