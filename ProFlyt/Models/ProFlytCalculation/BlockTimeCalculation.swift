//
//  BlockTimeCalculation.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/22/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

func degreesToRadians(value: Double) -> Double
{
    return value * M_PI / 180.0
}

func radiansToDegrees(value: Double) -> Double
{
    return value * 180 / M_PI
}

// U and V represent the components of thw wind vector
// in the true north and 90 degree direction respectively.
//
// The average of two or more vectors is the vector sum of their
// individual components, divided by the number of vectors.
//
// To determine the resulting average wind direction we can use the function atan2.
//
// As many wavpoints can be added as required.

class BlockTimeCalculation {
    
    // TRUE COURSE/DISTANCE FROM API
    var trueCourseDirection: Double!
    var trueDistance: Double!
    
    // FIELD CRUISE AIRSPEED(KTAS) : FROM CJO DATABASE
    var fieldCruiseAirspeedVelocity: Double!
    
//    var windTemps: [WindTemp]!
    
    var windAloftDatas: [WindAloftModel]!
    
    // Increase for class B Airfields?
    let engStartTaxiTime = 0.35
    
    required init(windAlofts: [WindAloftModel]!, flightDirection: Double!, distance: Double!, velocity: Double!) {
//        self.windTemps = windTemps
        self.windAloftDatas = windAlofts
        if flightDirection == nil
        {
            trueCourseDirection = 0.0
        }
        else
        {
            trueCourseDirection = flightDirection
        }
        if distance == nil
        {
            trueDistance = 0.0
        }
        else
        {
            trueDistance = distance
        }
        if velocity == nil
        {
            fieldCruiseAirspeedVelocity = 0.0
        }
        else
        {
            fieldCruiseAirspeedVelocity = velocity
        }
    }
    
    private func calcWindsU(windDirection: Double, windVelocity: Double) -> Double {
        return abs(windVelocity) * cos(degreesToRadians(windDirection))
    }
    private func calcWindsV(windDirection: Double, windVelocity: Double) -> Double {
        return abs(windVelocity) * sin(degreesToRadians(windDirection))
    }
    
    private func calcInterpolatedWindDataU() -> Double
    {
        var windDataU: Double = 0.0
        for windTemp in windAloftDatas
        {
            windDataU = windDataU + calcWindsU(windTemp.direction, windVelocity: windTemp.speed)
        }
        return windDataU / Double(windAloftDatas.count)
    }
    
    private func calcInterpolatedWindDataV() -> Double
    {
        var windDataV: Double = 0.0
        for windTemp in windAloftDatas
        {
            windDataV = windDataV + calcWindsV(windTemp.direction, windVelocity: windTemp.speed)
        }
        return windDataV / Double(windAloftDatas.count)
    } 
    
    private func calcInterpolatedWindDataDegree() -> Double
    {
        print(calcInterpolatedWindDataU())
        print(calcInterpolatedWindDataV())
        
        let result = atan2(calcInterpolatedWindDataU(), calcInterpolatedWindDataV())
        print(result)
        let result2 = atan(calcInterpolatedWindDataV()/calcInterpolatedWindDataU())
        print(result2)
        print(radiansToDegrees(result))
        return radiansToDegrees(atan(calcInterpolatedWindDataV()/calcInterpolatedWindDataU()))
    }
    
    private func calcInterpolatedWindDataDirection() -> Double
    {
        let interpolatedWindDataDegree = calcInterpolatedWindDataDegree()
        let result = interpolatedWindDataDegree < 0 ? interpolatedWindDataDegree + 360 : interpolatedWindDataDegree
        print("Interpolated Wind Data Direction \(result)")
        return result
    }
    
    private func calcInterpolatedWindDataVelocity() -> Double
    {
        let result = sqrt(pow(calcInterpolatedWindDataU(), 2) + pow(calcInterpolatedWindDataV(), 2))
        print("Interpolated Wind Data Velocity \(result)")
        return result
    }
    
    private func calcGroundSpeedVelocity() -> Double
    {
        return fieldCruiseAirspeedVelocity *
            sqrt(1 -
                pow(((calcInterpolatedWindDataVelocity() / fieldCruiseAirspeedVelocity) *
                        sin(degreesToRadians(calcInterpolatedWindDataDirection() - trueCourseDirection))), 2)) -
            calcInterpolatedWindDataVelocity() * cos(degreesToRadians(calcInterpolatedWindDataDirection() - trueCourseDirection))
    }
    
    private func calcNMPerMin() -> Double
    {
        return calcGroundSpeedVelocity() / 60
    }
    
    private func calcDurationTime() -> Double
    {
        return (trueDistance / calcNMPerMin()) / 60
    }
    
    // Needs to be adjustable
    private func calcAirborneXFactor() -> Double
    {
        return (0.05 * calcDurationTime()) + 0.3
    }
    
    func calcBlockTime() -> Double
    {
        return calcDurationTime() + calcAirborneXFactor() + engStartTaxiTime
    }
}

public class WindAloftModel {
    var speed: Double!
    var direction: Double!
}
