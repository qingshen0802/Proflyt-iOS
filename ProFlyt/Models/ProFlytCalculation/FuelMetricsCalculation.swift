//
//  FuelMetricsCalculation.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/22/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class FuelMetricsCalculation {
    
    // https://ar.flightaware.com/commercial/data/fuelprices
    var departureFieldFuelPrice: Double!
    // From CJO Database
    var burnRatePounds: Double!
    var stto: Double!
    
    required init (fuelPrice: Double!, burnRatePounds: Double!, stto: Double!) {
        if fuelPrice == nil
        {
            self.departureFieldFuelPrice = 0.0
        }
        else
        {
            self.departureFieldFuelPrice = fuelPrice
        }
        if burnRatePounds == nil
        {
            self.burnRatePounds = 0.0
        }
        else
        {
            self.burnRatePounds = burnRatePounds
        }
        if stto == nil
        {
            self.stto = 0.0
        }
        else
        {
            self.stto = stto
        }
    }
    
    private func calcBornRateGallons() -> Double
    {
        return burnRatePounds / 6.01
    }
    
    private func calcCTTOGallons() -> Double
    {
        return stto / 6.01
    }
    
    private func calcCruisePounds(blockTime: Double) -> Double
    {
        return burnRatePounds * blockTime
    }
    
    private func calcCruiseGallons(blockTime: Double) -> Double
    {
        return calcCruisePounds(blockTime) / 6.01
    }
    
    private func calcReservesPounds() -> Double
    {
        return burnRatePounds * 0.7
    }
    
    private func calcReservesGallons() -> Double
    {
        return calcReservesPounds() / 6.01
    }
    
    private func calcFuelRequiredPounds(blockTime: Double) -> Double
    {
        return stto + calcCruisePounds(blockTime) + calcReservesPounds()
    }
    
    private func calcFuelRequiredGallons(blockTime: Double) -> Double
    {
        return calcFuelRequiredPounds(blockTime) / 6.01
    }
    
    // Does not charge for reserve gas
    // Make LBS/Gallons conversion interchangaable
    func calcTotalFuelCost(blockTime: Double) -> Double
    {
        return departureFieldFuelPrice * (calcFuelRequiredGallons(blockTime) - calcReservesGallons())
    }
    
    func calcTotalRequiredFuelPounds(blockTime: Double) -> Double{
        return calcFuelRequiredPounds(blockTime)
    }
}
