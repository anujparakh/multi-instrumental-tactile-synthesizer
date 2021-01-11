//
//  GloveConstants.swift
//  MITS
//
//  Created by Anuj Parakh on 7/6/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation

class GloveConstants
{
    public static var LEFT_FLEX_MIN:[GloveFinger: Int] = [
        .Index: 580,
        .Middle: 565,
        .Ring: 625,
        .Pinky: 530
    ]
    
    public static var RIGHT_FLEX_MIN:[GloveFinger: Int] = [
        .Index: 580,
        .Middle: 565,
        .Ring: 625,
        .Pinky: 530
    ]
    
    public static var LEFT_FLEX_THRESHOLD:[GloveFinger: Int] = [
        .Index: 620,
        .Middle: 590,
        .Ring: 650,
        .Pinky: 550
    ]
    
    public static var RIGHT_FLEX_THRESHOLD:[GloveFinger: Int] = [
        .Index: 620,
        .Middle: 590,
        .Ring: 650,
        .Pinky: 550
    ]

    public static var LEFT_FLEX_MAX:[GloveFinger: Int] = [
        .Index: 675,
        .Middle: 660,
        .Ring: 700,
        .Pinky: 650
    ]
    
    public static var RIGHT_FLEX_MAX:[GloveFinger: Int] = [
        .Index: 675,
        .Middle: 660,
        .Ring: 700,
        .Pinky: 650
    ]
    
    public static func calculateThresholdValues()
    {
        for (key, flexVal) in LEFT_FLEX_MIN
        {
            LEFT_FLEX_THRESHOLD[key] = flexVal + 30
        }
        
        for (key, flexVal) in RIGHT_FLEX_MIN
        {
            RIGHT_FLEX_THRESHOLD[key] = flexVal + 30
        }
    }
    
    public static func printCalibratedValues()
    {
        let toPrint = "Left Min: \(LEFT_FLEX_MIN)\n"
                    + "Left Max: \(LEFT_FLEX_MAX)\n"
                    + "Right Min: \(RIGHT_FLEX_MIN)\n"
                    + "Right Max: \(RIGHT_FLEX_MAX)"
        DebugLogger.log(toPrint, .IMPORTANT)

    }
}
