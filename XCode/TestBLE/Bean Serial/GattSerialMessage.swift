//
//  GattSerialMessage.swift
//  TestBLE
//
//  Created by Anuj Parakh on 5/16/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation

class GattSerialMessage
{
    private var payloadLength = -1
    private var reserved = -1
    private var payload = Data()

    private var crc: UInt16?
    
    init(withPayload payload: Data)
    {
        payloadLength = payload.count
        reserved = 0 // dont really know what this is for
        self.payload = payload
    }
    
    func stringValue() -> String
    {
        let subDataToUse = payload.subdata(in: 2..<(payload.count-2))
        return String(data: subDataToUse, encoding: .utf8)!
    }
    
}
