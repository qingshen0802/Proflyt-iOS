//
//  PassenserCapacityCalculation.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/22/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class PassenserCapacityCalculation {
    
    // CJO DATABASE
    var maxTOWeight: Double!
    var emptyWeight: Double!
    var useableFuel: Double! // cannot be < fuel required
    
    var requiredCrewPilot1: Double!
    var requiredCrewPilot2: Double!
    var requiredCrewFltAttend1: Double!
    var requiredCrewFltAttend2: Double!
    
    // from customer request/database
    var totalPassengerWeight: Double! = 1600
    
    required init(maxTOWeight: Double!, emptyWeight: Double!, useableFuel: Double!, pilot1: Double!, pilot2: Double!, fltAttend1: Double!, fltAttend2: Double!, passengerWeight: Double!) {
        if maxTOWeight == nil
        {
            self.maxTOWeight = 0.0
        }
        else
        {
            self.maxTOWeight = maxTOWeight
        }
        
        if emptyWeight == nil
        {
            self.emptyWeight = 0.0
        }
        else
        {
            self.emptyWeight = emptyWeight
        }
        
        if useableFuel == nil
        {
            self.useableFuel = 0.0
        }
        else
        {
            self.useableFuel = useableFuel
        }
        
        if pilot1 == nil
        {
            self.requiredCrewPilot1 = 200.0
        }
        else
        {
            self.requiredCrewPilot1 = pilot1
        }
        
        if pilot2 == nil
        {
            self.requiredCrewPilot2 = 0.0
        }
        else
        {
            self.requiredCrewPilot2 = pilot2
        }
        
        if fltAttend1 == nil
        {
            self.requiredCrewFltAttend1 = 0.0
        }
        else
        {
            self.requiredCrewFltAttend1 = fltAttend1
        }
        
        if fltAttend2 == nil
        {
            self.requiredCrewFltAttend2 = 0.0
        }
        else
        {
            self.requiredCrewFltAttend2 = fltAttend2
        }
        
        if passengerWeight == nil
        {
            self.totalPassengerWeight = 1600
        }
        else
        {
            self.totalPassengerWeight = passengerWeight
        }
    }
    
    private func calcAvailableUsefulLoad() -> Double {
        return maxTOWeight - emptyWeight
    }
    
    
    private func calcPayloadAvailable(fuelMetrics: Double) -> Double
    {
        return calcAvailableUsefulLoad() - fuelMetrics
    }
    
    private func calcPassengerLuggageWeightAvailable(fuelMetrics: Double) -> Double
    {
        return calcPayloadAvailable(fuelMetrics) - requiredCrewPilot1 - requiredCrewPilot2 - requiredCrewFltAttend1 - requiredCrewFltAttend2
    }
    
    func calcWeightAvailable(fuelMetrics: Double) -> Double
    {
        return calcPassengerLuggageWeightAvailable(fuelMetrics) - totalPassengerWeight
    }
    
}
