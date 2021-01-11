//
//  DebugLogger.swift
//  MITS
//
//  Created by Anuj Parakh on 1/5/21.
//  Copyright © 2021 Anuj Parakh. All rights reserved.
//

import Foundation


class DebugLogger
{
    // Switch to false to turn off all logging
    public static let DEBUG_MODE = true
    
    public enum DEBUG_LEVEL
    {
        case ERROR
        case IMPORTANT
        case INFO
        case SILLY
    }
    
    // Set logging level toggles here
    public static var DEBUG_LEVEL_TOGGLES = [
        DEBUG_LEVEL.ERROR: true,
        DEBUG_LEVEL.IMPORTANT: true,
        DEBUG_LEVEL.INFO: false,
        DEBUG_LEVEL.SILLY: false,
    ]
    
    private static let DEBUG_LEVEL_PRINTS = [
        DEBUG_LEVEL.ERROR: "\n🛑 ERROR: ",
        DEBUG_LEVEL.IMPORTANT: "\n🔥 IMPORTANT: ",
        DEBUG_LEVEL.INFO: "\n📗 INFO: " ,
        DEBUG_LEVEL.SILLY: "\n💬 SILLY: ",
    ]
    
    // Global logging function to be used everywhere
    public static func log(_ toLog: String, _ debugLevel: DEBUG_LEVEL)
    {
        if DEBUG_MODE && DEBUG_LEVEL_TOGGLES[debugLevel]!
        {
            print(DEBUG_LEVEL_PRINTS[debugLevel]!)
            print(toLog)
        }
    }
    
}
