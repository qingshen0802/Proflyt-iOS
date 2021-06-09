//
//  FlightModel.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/30/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import Foundation
import Parse
import APTimeZones

protocol FlightModelDelegate {
    func addAircraft(aircraftFlight: AircraftFlight?)
}
class FlightModel {
    let mile = 1852.0 // meters
    let meter: Double = 3.28084 // foot
    let cal = NSCalendar.currentCalendar()
    
    var mDelegate: FlightModelDelegate?
    
    func setData(aircrafts: [PFObject]!, departureAirport: PFObject!, destinationAirport: PFObject!, departureDateTime: NSDate!, destinationDateTime: NSDate!, passengerNumber: Int) {
        let departureLat = departureAirport!["latitude"] as! Double
        let departureLng = departureAirport!["longitude"] as! Double
        let destinationLat = destinationAirport!["latitude"] as! Double
        let destinationLng = destinationAirport!["longitude"] as! Double
        
        //This part is converting departure time.
        // As you can see, the function receive departure latitude and longitude and time and calculate zulu time with them.
        let convertedDepartureDateTime = convertTimeZone(departureLat, longitude: departureLng, departureTime: departureDateTime)
        
        // distance between two locations
        let departureLocation: CLLocation = CLLocation(latitude: departureLat, longitude: departureLng)
        let destinationLocation: CLLocation = CLLocation(latitude: destinationLat, longitude: destinationLng)
        let distance: Double = departureLocation.distanceFromLocation(destinationLocation) / mile
        
        //Calculating true north direction part
        //This function receives the latitude and longitudes of departure and destination airports.And based on them, it will calculate direction as Degree.
        let direction = calculateDirection(departureLat, departureLong: departureLng, destinationLati: destinationLat, destinationLong: destinationLng)
        print("Flight Direction \(direction)")
        
        //This part is implementing Wind Aloft Data algorithm
        for aircraft: PFObject in aircrafts! {
            let availableSeatNumber = aircraft[kCharterOperatorSeatsAvailable] as! Int
            if availableSeatNumber >= passengerNumber {
            
                // Cruise Airspeed(KTAS)
                // Cruise airspeed, This values are from DB on Parse.com.
                let cruiseAirspeed: Int = aircraft[kCharterOperatorCruisKTAS] as! Int
//                println(cruiseAirspeed)

                // Cruise Altitude, This is prefered cruise altitude for plane.
                var cruiseAltitude: Int = Int((aircraft[kCharterOperatorPreferredCruiseAltitude] as! String).stringByReplacingOccurrencesOfString("FL", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))!

//                println(cruiseAltitude)
                let aircraftName = aircraft[kCharterOperatorName] as! String
                
                print("Flight name: \(aircraftName)")
            
                if IS_TESTING == true
                {
                    cruiseAltitude = 320
                }
                let fl = Double(cruiseAltitude * 100)

                var altitude: Int = 0
                // Getting altitude for reading data from wind aloft data file.
                // Based on aircraft's cruise altitude, it get approx value for wind data file.
                // So if the plane's altitude is 25000 feet, the altitude for data file will be setted as 24000 feet and read wind datas for 24000 feet's
                for ft: Int in fts
                {
                    if abs(Double(altitude) - fl) > abs(Double(ft) - fl)
                    {
                        altitude = ft
                    }
                }
                
                // If there's no prefered altitude for plane, the altitude will be 8000 as default and read datas for that.
                if altitude == 0
                {
                    altitude = fts[0]
                }
                
                // Getting mid points part.
                let midPoints = getInterMediatPoints(departureLat, departureLong: departureLng, destinationLati: destinationLat, destinationLong: destinationLng, distance: distance)
                // Then get approx points of mid points for read wind datas form file.
                let convertedInterPoints = convertPoint(midPoints)
                
                // This is the order for getting wind datas from file.
                // That function receives altitude, converted departure time and converted mid point datas.
                // Let's go to function body
                let windTemps = getWindAloftDataFromFile(altitude, departureTime: convertedDepartureDateTime, pointDatas: convertedInterPoints)
                
                // calculating block time
                // This function receives Wind datas and flight direction and distance, and velocity and produce block time.
                let blockTime = BlockTimeCalculation(windAlofts: windTemps, flightDirection: direction, distance: distance, velocity: Double(cruiseAirspeed)).calcBlockTime()
//                let arrivalDateTime = self.calcArrivalDateTime(convertedDepartureDateTime, blockTime: blockTime, destinationLat: latitude, destinationLng: longitude)
                let arrivalDateTime = self.calcArrivalDateTime(convertedDepartureDateTime, blockTime: blockTime, latitude: destinationLat, longitude: destinationLng)
                if blockTime != Double.NaN && (destinationDateTime == nil || destinationDateTime!.timeIntervalSince1970 >= arrivalDateTime.timeIntervalSince1970)
                {
                    AirportManager.getAirportFuelPrice(nil, block: { (result: AnyObject?, error: NSError?) -> Void in
                        if error == nil && result != nil
                        {
                            let price100llfs = ((result![kAirportFuelPrice100llFS] as! NSString).substringFromIndex(1) as NSString).doubleValue
                            let burnRatePPH = aircraft[kCharterOperatorBurnRatePPH] as! Double
                            let stto = 0.0//(aircraft[kCharterOperatorSTTO] as! NSString).doubleValue
                            let fuelPrice = FuelMetricsCalculation(fuelPrice: price100llfs, burnRatePounds: burnRatePPH, stto: stto).calcTotalFuelCost(blockTime)
                            let requiredFuel = FuelMetricsCalculation(fuelPrice: price100llfs, burnRatePounds: burnRatePPH, stto: stto).calcTotalRequiredFuelPounds(blockTime)
                            
                            let pricePerHour = aircraft[kCharterOperatorPricePerHour] as! Double

                            let totalPrice = PriceCalculation(crewExpenses: nil, dailyFee: nil, landingFee: nil, parkingFee: nil, hourlyJetCost: pricePerHour, segmentFees: nil, customsFees: nil).calcTotalCost(fuelPrice, blockTime: blockTime)

                            let luggageRestrictions = PassenserCapacityCalculation(maxTOWeight: aircraft[kCharterOperatorMaxTOWeightLBS] as! Double, emptyWeight: aircraft[kCharterOperatorEmptyWeightLBS] as! Double, useableFuel: aircraft[kCharterOperatorMaxFuelCapacityLBS] as! Double, pilot1: nil, pilot2: nil, fltAttend1: nil, fltAttend2: nil, passengerWeight: 250.0 * Double(passengerNumber)).calcWeightAvailable(requiredFuel)

                            let aircraftFlight = AircraftFlight(charterOperator: aircraft, departureDateTime: departureDateTime, destinationDateTime: arrivalDateTime, blockTime: blockTime, totalPrice: totalPrice, luggageRestrictions: luggageRestrictions)

                            if self.mDelegate != nil
                            {
                                self.mDelegate?.addAircraft(aircraftFlight)
                            }
                            else if self.mDelegate != nil
                            {
                                self.mDelegate?.addAircraft(nil)
                            }
                        }
                        else if self.mDelegate != nil
                        {
                            self.mDelegate?.addAircraft(nil)
                        }
                    })
                }
                else if self.mDelegate != nil
                {
                    self.mDelegate?.addAircraft(nil)
                }
            }
            else if self.mDelegate != nil
            {
                self.mDelegate?.addAircraft(nil)
            }
        }
    }
    
    func calculateDirection(departureLati: Double, departureLong: Double, destinationLati: Double, destinationLong: Double) -> Double{
        let tanAlpha = (abs(departureLong - destinationLong) * 60 * mile) / (abs(departureLati - destinationLati) * 60 * mile)
        var direction: Double!
        if departureLong > destinationLong {
            if departureLati > destinationLati {
                direction = 180 + radiansToDegrees(atan(tanAlpha))
            } else {
                direction = 360 - radiansToDegrees(atan(tanAlpha))
            }
        } else {
            if departureLati > destinationLati {
                direction = 180 - radiansToDegrees(atan(tanAlpha))
            } else {
                direction = radiansToDegrees(atan(tanAlpha))
            }
        }
        
        return direction
    }
    
    private func calcArrivalDateTime(departureDateTime: NSDate!, blockTime: Double!, latitude: Double, longitude: Double) -> NSDate! {
        if departureDateTime != nil && blockTime != nil
        {
            var hour = Int(blockTime)
            let minute = Int(60.0 * (blockTime - Double(hour)))
            let day = Int(hour / 24)
            hour = hour - day * 24
            let timeInterval: NSTimeInterval = NSTimeInterval(day * 60 * 60 * 24 + hour * 60 * 60 + minute * 60)
            let destinationDateTime = departureDateTime.dateByAddingTimeInterval(timeInterval)// GMT time
            
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let timeZone = APTimeZones.sharedInstance().timeZoneWithLocation(location)
            let timeZoneOffset = Double(timeZone.secondsFromGMT)
            let localTimeInterval = destinationDateTime.timeIntervalSinceReferenceDate + timeZoneOffset
            let localTime = NSDate(timeIntervalSinceReferenceDate: localTimeInterval)
            return localTime
        }
        return nil
    }
    
    //This is the body of function.
    func convertTimeZone(latitude: Double, longitude: Double, departureTime: NSDate) -> NSDate{
        let location = CLLocation(latitude: latitude, longitude: longitude)
        //First I got timezone of the location.
        let timeZone = APTimeZones.sharedInstance().timeZoneWithLocation(location)
        //And convert the time as zulu time(GMT time zone).
        let timeZoneOffset = Double(timeZone.secondsFromGMT)
        let gmtTimeInterval = departureTime.timeIntervalSinceReferenceDate - timeZoneOffset
        let gmtDate = NSDate(timeIntervalSinceReferenceDate: gmtTimeInterval)
        //gmtDate is the converted time as zulu time zone.
        return gmtDate
    }
    
    // This is the getting mid points function's body.
    // It receives coordinates of departure and destination airports and direct distance.
    // Based on that, it will calculate mid point values. This algorithm also contains some mathematical theory.
    private func getInterMediatPoints(departureLati: Double, departureLong: Double, destinationLati: Double, destinationLong: Double, distance: Double) -> [IntermidiatePoints]{
        
        var points = [IntermidiatePoints]()
        // X: Longitude, Y: Latitude
        let fromX = departureLong
        let fromY = departureLati
        let toX = destinationLong
        let toY = destinationLati
        _ = 60 * mile
        
        print("Departure Latitude   \(fromY)")
        print("Departure Longitude   \(fromX)")
        print("Destination Latitude   \(toY)")
        print("Destination Longitude   \(toX)")
        print("Distance   \(distance)")
        
        let numberOfPoint = Int(distance/100)
        // Get prefix A and B
        let pre_a = (fromY - toY)/(fromX - toX)
        let pre_b = fromY - pre_a * fromX
        
        print("\(pre_a),  \(pre_b)")
        
        points.append(IntermidiatePoints(lat: departureLati, long: departureLong))
        for index in 1...numberOfPoint
        {
            if fromX > toX
            {
                let pointXatIndex = fromX - 100 * Double(index)/(sqrt(pow(pre_a, 2) + 1) * 60)
                let pointYatIndex = pre_a * pointXatIndex + pre_b
                print("Point \(index) Latitude  \(pointYatIndex)  Longitude  \(pointXatIndex)")
                points.append(IntermidiatePoints(lat: pointYatIndex, long: pointXatIndex))
            }
            else
            {
                let pointXatIndex = fromX + 100 * Double(index)/(sqrt(pow(pre_a, 2) + 1) * 60)
                let pointYatIndex = pre_a * pointXatIndex + pre_b
                print("Point \(index) Latitude  \(pointYatIndex)  Longitude  \(pointXatIndex)")
                points.append(IntermidiatePoints(lat: pointYatIndex, long: pointXatIndex))
            }
        }
        points.append(IntermidiatePoints(lat: destinationLati, long: destinationLong))
        return points
    }
    // This is the body.
    // Based on the altitude, it determines the file for the altitude. If altitude is 10000, then file will be 10000 and read datas from it
    // After confirming file, it calculates the index of speed and direction value's offset based on the time and mid point values.
    private func getWindAloftDataFromFile(aloft: Int, departureTime: NSDate, pointDatas: [IntermidiatePoints]) -> [WindAloftModel]{
        
        var windData:[WindAloftModel] = [WindAloftModel]()
        let header_length = 11
        let fileName = String(aloft)
        print("AirCraft Aloft: \(fileName)")
        let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "", inDirectory: "WindData")
        let file = NSData(contentsOfFile: filePath!)
        
        // calculate circle number for specific time.
        let dateIndex = getIndexOfDate(departureTime)
        let hourIndex = getIndexOfTime(departureTime)
        let circleNum: Int = (4 * (dateIndex - 1)) + (hourIndex - 1)
        
        print("Date Index: \(dateIndex)")
        print("Time Index: \(hourIndex)")
        print("Cycle Number: \(circleNum)")// Output log for circle number
        var i = UInt16()
        // And get speed and direction values for mid points. This algorithm also contains mathematics.
        // And I implemented formular for it from Adam.
        for point in pointDatas
        {
            let windTemp = WindAloftModel()
            let latIndex = Int((wSTART_LAT - point.latitude)/wDELTA)
            let longIndex = Int((point.longitude - wSTART_LONG)/wDELTA)
            // Calculating speed and direction offset.
            let speedOffset = header_length + (((circleNum * wNUM_LAT + latIndex) * wNUM_LONG + longIndex) * 2 + 0) * 2
            let directionOffset = header_length + (((circleNum * wNUM_LAT + latIndex) * wNUM_LONG + longIndex) * 2 + 1) * 2
            
            // And read wind speed and direction
            let speedrange = NSRange(location: speedOffset, length: 2)
            file?.getBytes(&i, range: speedrange)
            var temp: Double = Double(i)
            windTemp.speed = temp/100
            print("Speed: \(windTemp.speed)")
            let directionrange = NSRange(location: directionOffset, length: 2)
            file?.getBytes(&i, range: directionrange)
            temp = Double(i)
            windTemp.direction = temp/100
            print("Direction: \(windTemp.direction)")
            
            windData.append(windTemp)
        }
        return windData
    }
    
    private func getIndexOfDate(date: NSDate) -> Int{
        let endDate = date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let unit: NSCalendarUnit = NSCalendarUnit.Day
        let compo = cal.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: endDate)
        
        let year = compo.year
        let start = String(year) + "-01-01"
        let startDate: NSDate = dateFormatter.dateFromString(start)!
        
        let component = cal.components(unit, fromDate: startDate, toDate: endDate, options: [])

        return component.day + 1
    }
    
    private func getIndexOfTime(date: NSDate) -> Int{
        let component = cal.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: date)
        if component.hour > 18 {
            return 4
        } else if component.hour > 12 {
            return 3
        } else if component.hour > 6 {
            return 2
        } else {
            return 1
        }
    }
    
    // This is the body of that function.
    // It receives original mid point values and convert them to approx values.
    private func convertPoint(points:[IntermidiatePoints]) -> [IntermidiatePoints]{
        var convertedPoints: [IntermidiatePoints] = [IntermidiatePoints]()
        for point in points{
            let indexLat = Int((wSTART_LAT - point.latitude)/wDELTA)
            let indexLong = Int((point.longitude - wSTART_LONG)/wDELTA)
            
            var tempLong = wSTART_LONG + Double(indexLong + 1) * wDELTA
            var tempLat = wSTART_LAT - Double(indexLat + 1) * wDELTA
            
            if abs(tempLat - point.latitude) < wDELTA/2 {
                tempLat = wSTART_LAT - Double(indexLat + 1) * wDELTA
            }else{
                tempLat = wSTART_LAT - Double(indexLat) * wDELTA
            }
            
            if abs(tempLong - point.longitude) < wDELTA/2 {
                tempLong = wSTART_LONG + Double(indexLong + 1) * wDELTA
            }else{
                tempLong = wSTART_LONG + Double(indexLong) * wDELTA
            }
            
            print("Latitude:\(tempLat)  Longitude:\(tempLong)")
            convertedPoints.append(IntermidiatePoints(lat: tempLat, long: tempLong))
        }
        return convertedPoints
    }
}

class IntermidiatePoints {
    var latitude: Double!
    var longitude: Double!
    
    init(lat: Double, long: Double){
        latitude = lat
        longitude = long
    }
}

public class AircraftFlight {
    var blockTime: Double!
    var charterOperator: AnyObject!
    var departureDateTime: NSDate!
    var destinationDateTime: NSDate!
    var blockTimeString: String!
    var totalPrice: Double!
    var pricePerSeat: Double!
    var luggageRestrictions: Double!
    
    required public init(charterOperator: AnyObject?, departureDateTime: NSDate?, destinationDateTime: NSDate?, blockTime: Double?, totalPrice: Double?, luggageRestrictions: Double?) {
        self.blockTime = blockTime
        self.charterOperator = charterOperator
        self.departureDateTime = departureDateTime
        self.destinationDateTime = destinationDateTime
        self.totalPrice = totalPrice
        self.pricePerSeat = totalPrice! / (charterOperator![kCharterOperatorSeatsAvailable] as! Double)
        self.luggageRestrictions = luggageRestrictions
        calcDestinationDateTime()
    }
    
    private func calcDestinationDateTime() {
        if blockTime != nil
        {
            let hour = Int(blockTime)
            let minute = Int(60.0 * (blockTime - Double(hour)))
//            var day = Int(hour / 24)
//            hour = hour - day * 24
            blockTimeString = "\(minute)min"
            if hour > 0
            {
                blockTimeString = "\(hour)h \(blockTimeString)"
//                if day > 0
//                {
//                    blockTimeString = "\(day)d \(blockTimeString)"
//                }
            }
        }
    }
}
