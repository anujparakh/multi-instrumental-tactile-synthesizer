//
//  GattPacket.swift
//  TestBLE
//
//  Created by Anuj Parakh on 5/16/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation

class GattPacket
{
    public var startBit = false
    public var messageCount = -1
    public var gattPacketDescendingCount = -1
    public var data = Data()
    
    init(withData characteristicData: Data)
    {
        // Make sure packet isn't too small
        if characteristicData.count < 2
        {
            print("Data is too small!")
            return
        }
        
        // Deconstruct message header
        let dataBytes = [UInt8](characteristicData)
        let firstByte = dataBytes[0]
        
        // get the start bit
        if ((firstByte & 0x80) != 0)
        {
            startBit = true
        }
        
        // get the message count
        messageCount = Int((firstByte & 0x60) >> 5)
        
        // get the gatt packet descending count
        gattPacketDescendingCount = Int(firstByte & 0x1F)
        
        self.data = characteristicData.subdata(in: 1..<(characteristicData.count))
    }
    
    // TODO: Add stuff to construct message with header
}
