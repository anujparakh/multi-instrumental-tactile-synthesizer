//
//  ParticlePeripheral.swift
//  TestBLE
//
//  Created by Anuj Parakh on 2/23/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import CoreBluetooth

class BTConstants: NSObject
{
    public static let nanoID = CBUUID.init(string:  "26548447-3cd0-4460-b683-43b332274c2b")
    public static let imuCharacteristicID = CBUUID.init(string:  "20831a75-7aaf-4284-888f-47c41dc6b976")
}
