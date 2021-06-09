//
//  PriceCalculation.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/22/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class PriceCalculation: NSObject {
   
    // From CJO Database
    var overnightCrewExpenses: Double!
    var aircraftIdleDailyFee: Double!
    
    // www.airportcharges.com
    var landingFee: Double!
    var parkingFee: Double!
    
    var preFuelHourlyJetCost: Double! // From CJO Database
    
    var segmentFees: Double! // NBAA FORMULA
    var customsFees: Double!
    
    required init(crewExpenses: Double!, dailyFee: Double!, landingFee: Double!, parkingFee: Double!, hourlyJetCost: Double!, segmentFees: Double!, customsFees: Double!) {
        if crewExpenses == nil
        {
            self.overnightCrewExpenses = 0.0
        }
        else
        {
            self.overnightCrewExpenses = crewExpenses
        }
        if dailyFee == nil
        {
            self.aircraftIdleDailyFee = 0.0
        }
        else
        {
            self.aircraftIdleDailyFee = dailyFee
        }
        if landingFee == nil
        {
            self.landingFee = 0.0
        }
        else
        {
            self.landingFee = landingFee
        }
        if parkingFee == nil
        {
            self.parkingFee = 0.0
        }
        else
        {
            self.parkingFee = parkingFee
        }
        if hourlyJetCost == nil
        {
            self.preFuelHourlyJetCost = 0.0
        }
        else
        {
            self.preFuelHourlyJetCost = hourlyJetCost
        }
        if segmentFees == nil
        {
            self.segmentFees = 0.0
        }
        else
        {
            self.segmentFees = segmentFees
        }
        if customsFees == nil
        {
            self.customsFees = 0.0
        }
        else
        {
            self.customsFees = customsFees
        }
    }
    
    private func calcPreFuelHourlyJetCostTotal(blockTime: Double) -> Double
    {
        return preFuelHourlyJetCost * blockTime
    }
    
    private func calcFuelCost(fuelMetrics: Double, blockTime: Double) -> Double
    {
        return fuelMetrics * blockTime
    }
    
    private func calcProFlytFee(fuelMetrics: Double, blockTime: Double) -> Double
    {
        return 0.07 * (calcPreFuelHourlyJetCostTotal(blockTime) + fuelMetrics)
    }
    
    // 7.5% TAX + 2.0% PMT PROC FEE
    private func calcTaxProcessingFee(fuelMetrics: Double, blockTime: Double) -> Double
    {
        return ((calcPreTaxCost(fuelMetrics, blockTime: blockTime) + calcProFlytFee(fuelMetrics, blockTime: blockTime))) * 0.095
    }
    
    private func calcPreTaxCost(fuelMetrics: Double, blockTime: Double) -> Double
    {
        return calcProFlytFee(fuelMetrics, blockTime: blockTime) + customsFees + segmentFees + fuelMetrics + calcPreFuelHourlyJetCostTotal(blockTime) + parkingFee + landingFee + aircraftIdleDailyFee + overnightCrewExpenses
    }
    
    func calcTotalCost(fuelMetrics: Double, blockTime: Double) -> Double
    {
        return calcTaxProcessingFee(fuelMetrics, blockTime: blockTime) + calcPreTaxCost(fuelMetrics, blockTime: blockTime)
    }
}
