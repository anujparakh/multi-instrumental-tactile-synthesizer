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
    public static var FLEX_MIN = [
        0: 580,
        1: 565,
        2: 625,
        3: 530
    ]

    public static var FLEX_THRESHOLD = [
        0: 620,
        1: 590,
        2: 650,
        3: 550
    ]
    
    public static var FLEX_MAX = [
        0: 675,
        1: 660,
        2: 700,
        3: 650
    ]
    
    public static func calculateThresholdValues()
    {
        for (key, flexVal) in FLEX_MIN
        {
            FLEX_THRESHOLD[key] = flexVal + 20
        }
    }
}
