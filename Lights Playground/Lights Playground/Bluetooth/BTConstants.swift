//
//  BTConstants.swift
//  MITS
//
//  Created by Anuj Parakh on 4/18/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import CoreBluetooth

class BTConstants: NSObject
{
    
    // Nano IDs
    public static let nanoIDLeft = CBUUID.init(string:  "26548447-3cd0-4460-b683-43b332274c2b")
    public static let nanoIDRight = CBUUID.init(string:  "26548447-3cd0-4460-b683-43b332274c2c")
    public static let imuCharacteristicID = CBUUID.init(string:  "20831a75-7aaf-4284-888f-47c41dc6b976")
    public static let flexCharacteristicID = CBUUID.init(string: "43b513cf-08aa-4bd9-bc58-3f626a4248d8")
    
    // Bean IDs
    public static let beanAdvertisingID = CBUUID.init(string: "a495ff10-c5b1-4b44-b512-1370f02d74de")
    // TODO: Write the UUIDs
    public static let beanIDLeft  = UUID.init(uuidString: "880EC696-6A31-09B6-9D4D-3825CA2FDF4D")! // iOS
//    public static let beanIDLeft  = UUID.init(uuidString: "C157E54F-4DC4-4D0B-9048-7F0C8C586E21")! // macOS
    public static let beanIDRight = UUID.init(uuidString: "FE3A28BC-E884-6080-97CA-9EFDC23D87D1")!
}

