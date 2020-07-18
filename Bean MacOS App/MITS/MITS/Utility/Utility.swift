//
//  Utility.swift
//  MITS
//
//  Created by Anuj Parakh on 7/5/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation


// MARK:- DEBUG Logging Stuff

let DEBUG_MODE = true

enum DEBUG_LEVEL
{
    case ERROR
    case IMPORTANT
    case INFO
    case SILLY
}

var DEBUG_LEVEL_TOGGLES = [
    DEBUG_LEVEL.ERROR: true,
    DEBUG_LEVEL.IMPORTANT: true,
    DEBUG_LEVEL.INFO: false,
    DEBUG_LEVEL.SILLY: false,
]

let DEBUG_LEVEL_PRINTS = [
    DEBUG_LEVEL.ERROR: "\n============== ERROR ==============\n",
    DEBUG_LEVEL.IMPORTANT: "\n************** IMPORTANT **************\n",
    DEBUG_LEVEL.INFO: "\n-------------------- INFO --------------------\n" ,
    DEBUG_LEVEL.SILLY: "",
]

// Global logging function to be used everywhere
func debugLog(_ toLog: String, _ debugLevel: DEBUG_LEVEL)
{
    if DEBUG_MODE && DEBUG_LEVEL_TOGGLES[debugLevel]!
    {
        print(DEBUG_LEVEL_PRINTS[debugLevel]!)
        print(toLog)
    }
}

// MARK:- Validation Functions

func validateFlexVals(_ flexVals: [String: AnyObject]) -> Bool
{
    // Make sure values for all 4 fingers exist
    return flexVals ["f1"] != nil &&
           flexVals ["f2"] != nil &&
           flexVals ["f3"] != nil &&
           flexVals ["f4"] != nil
}
