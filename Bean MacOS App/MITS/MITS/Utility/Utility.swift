//
//  Utility.swift
//  MITS
//
//  Created by Anuj Parakh on 7/5/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation


let loggingOn = true

// Global logging function to be used everywhere
func debugLog(_ toLog: String)
{
    if loggingOn
    {
        print(toLog)
    }
}
