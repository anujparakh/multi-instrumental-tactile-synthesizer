//
//  Utility.swift
//  MITS
//
//  Created by Anuj Parakh on 7/5/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation


// MARK:- Data Related Functions

/// Validates that none of the finger values in the flex sensor values in the JSON dictionary is missing
func validateFlexValsJson(_ flexVals: JSONDictionary) -> Bool
{
    // Make sure values for all 4 fingers exist
    return flexVals ["f1"] != nil &&
           flexVals ["f2"] != nil &&
           flexVals ["f3"] != nil &&
           flexVals ["f4"] != nil
}

/// Given a JSONDictionary with flex values, converts it to the proper type FlexValuesDictionary
func convertJSONDictionary(_ toConvert: JSONDictionary) -> FlexValuesDictionary
{
    var toReturn = FlexValuesDictionary()
    
    toReturn[.Index]  = toConvert["f1"] as? Int
    toReturn[.Middle] = toConvert["f2"] as? Int
    toReturn[.Ring]   = toConvert["f3"] as? Int
    toReturn[.Pinky]  = toConvert["f4"] as? Int
    
    return toReturn
}

/// Given flex sensor values and threshold values for each finger, evaluates the numeric hand sign (FlexSign)
func evaluateSign(fromValues flexValues: FlexValuesDictionary, thresholdValues: FlexValuesDictionary) -> FlexSign
{
    var evaluatedSign = FlexSign.four
    if flexValues[.Index]! < thresholdValues[.Index]!
    {
        evaluatedSign = FlexSign.zero
    }
    else if flexValues[.Middle]! < thresholdValues[.Middle]!
    {
        evaluatedSign = FlexSign.one
    }
    else if flexValues[.Ring]! < thresholdValues[.Ring]!
    {
        evaluatedSign = FlexSign.two
    }
    else if flexValues[.Pinky]! < thresholdValues[.Pinky]! + 25
    {
        evaluatedSign = FlexSign.three
    }
    return evaluatedSign
}

// MARK:- Music Related Utility Functions

/// Given a finger and the flex value, calculates the appropriate volume from 0-127
/// based on the finger's FLEX_MIN and FLEX_MAX values for the left hand
func calculateVolumeLeft(for finger: GloveFinger, value flexValue: Int) -> UInt8
{
    var newVolume = 127 * (flexValue - GloveConstants.LEFT_FLEX_MIN[finger]!) / (GloveConstants.LEFT_FLEX_MAX[finger]! - GloveConstants.LEFT_FLEX_MIN[finger]!)
    if newVolume < 0
    {
        newVolume = 0
    }
    else if newVolume > 127
    {
        newVolume = 127
    }
    return UInt8(newVolume)
}

/// Given a finger and the flex value, calculates the appropriate volume from 0-127
/// based on the finger's FLEX_MIN and FLEX_MAX values for the right hand
func calculateVolumeRight(for finger: GloveFinger, value flexValue: Int) -> UInt8
{
    var newVolume = 127 * (flexValue - GloveConstants.RIGHT_FLEX_MIN[finger]!) / (GloveConstants.RIGHT_FLEX_MAX[finger]! - GloveConstants.RIGHT_FLEX_MIN[finger]!)
    if newVolume < 0
    {
        newVolume = 0
    }
    else if newVolume > 127
    {
        newVolume = 127
    }
    return UInt8(newVolume)
}

// MARK:- Useful Types

typealias JSONDictionary = [String: AnyObject]
typealias FlexValuesDictionary = [GloveFinger: Int]
typealias FlexCallbackFunction = ((FlexValuesDictionary) -> Void)
typealias ConnectionStatusCallbackFunction = ((ConnectionStatus) -> Void)

enum GloveFinger: CaseIterable
{
    case Index
    case Middle
    case Ring
    case Pinky
}

enum ConnectionStatus: String
{
    case Off = "Bluetooth Unavailable"
    case Scanning = "Scanning"
    case Connected = "Connected"
    case Disconnected = "Disconnected"
}
