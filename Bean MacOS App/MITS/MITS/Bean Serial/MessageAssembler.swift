//
//  MessageAssembler.swift
//  TestBLE
//
//  Created by Anuj Parakh on 5/16/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation

class MessageAssembler
{
    // Member variables with default values
    private var payload: Data = Data()
    private var messageIndex = -1
    private var gattPacketIndex = -1
    private var firstMessage = true
    
    func isMessageComplete() -> Bool
    {
        return false
    }
    
    func processPacket(_ packet: GattPacket) -> GattSerialMessage?
    {
        
        // Error Checking
        if packet.startBit
        {
            if (firstMessage)
            {
                firstMessage = false
            }
            else
            {
                messageIndex += 1
                if packet.messageCount != ((messageIndex) % 4)
                {
                    print("Error: Message Index out of sequence")
                    return nil
                }
            }
            
            messageIndex = packet.messageCount
            gattPacketIndex = packet.gattPacketDescendingCount
        }
        else
        {
            if packet.messageCount != messageIndex
            {
                print("Error: Message Count Problem")
                return nil
            }
            
            gattPacketIndex -= 1
            if packet.gattPacketDescendingCount != gattPacketIndex
            {
                print("Error: Gatt Packet Descending Count Problem")
                return nil
            }
        }
        
        // POSSIBLE CASES:
        // 1. Start Packet with no payload data
        // 2. Non-Start Packet and partial payload data
        // 3. Start Packet with partial payload data (ERROR)
        // 4. Non-Start Packet with no payload data (ERROR)
        
        let isPartialMessage: Bool = (payload.count > 0)
        if (packet.startBit && !isPartialMessage) // Case 1
        {
            payload = packet.data
        }
        
        else if(!packet.startBit && isPartialMessage) // Case 2
        {
            payload.append(packet.data)
        }
        
        else if (packet.startBit && isPartialMessage) // Case 3
        {
            print("Error: Start Packet has some payload")
            return nil
        }
        
        else if (!packet.startBit && !isPartialMessage) // Case 4
        {
            print("Error: No Payload in non-start packet")
        }
        
        // Now check if this was the last packet and message is complete
        if (packet.gattPacketDescendingCount == 0)
        {
            // Create message with entire payload and return it
            let message = GattSerialMessage(withPayload: payload)
            payload = Data() // empty the payload
            return message
        }
        
        return nil
    }
    
}
