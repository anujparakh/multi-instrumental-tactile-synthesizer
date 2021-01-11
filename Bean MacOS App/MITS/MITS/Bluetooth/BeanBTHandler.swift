//
//  BTHandler.swift
//  MITS
//
//  Created by Anuj Parakh on 4/18/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation
import CoreBluetooth
import os

class BeanBTHandler: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate
{
    // MARK:- Private Data Members and Functions
    private var centralManager: CBCentralManager!
    private var mitsBeanPeripheral: CBPeripheral!
    private var messageAssembler: MessageAssembler!
    
    // UUIDs
    private var mitsUUID: CBUUID!
    private var beanUUID: UUID!
    
    // Callbacks
    public var flexCallback: FlexCallbackFunction?
    public var imuCallback: FlexCallbackFunction?
    public var connectionStatusCallback: ConnectionStatusCallbackFunction?
    
    private func updateConnectionStatus(_ status: ConnectionStatus)
    {
        if let callback = connectionStatusCallback
        {
            callback(status)
        }
        else
        {
            DebugLogger.log("No connection callback\n(status = \(status))", .INFO)
        }
    }
    
    // MARK:- CBCentralManager Delegate Functions
    
    // Callback when central manager's state is updated
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch central.state
        {
            
        case .unknown:
            DebugLogger.log("Central Manager's State is Unknown", .ERROR)
            updateConnectionStatus(.Off)
        case .resetting:
            DebugLogger.log("Central Manager's State is Resetting", .IMPORTANT)
        case .unsupported:
            DebugLogger.log("BLE Unsupported", .ERROR)
            updateConnectionStatus(.Off)
        case .unauthorized:
            DebugLogger.log("BLE Unauthorized", .ERROR)
            updateConnectionStatus(.Off)
        case .poweredOff:
            DebugLogger.log("BLE powered off", .ERROR)
            updateConnectionStatus(.Off)
        case .poweredOn:
            updateConnectionStatus(.Scanning)
            // Scan for any peripherals
            if let uuid = mitsUUID
            {
                centralManager.scanForPeripherals(withServices: [uuid])
                DebugLogger.log("BLE On and Scanning", .IMPORTANT)
            }
        @unknown default:
            DebugLogger.log ("Central Manager Don't know :(", .ERROR)
        }
    }
    
    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        // Check if it's the right device
        if peripheral.identifier != beanUUID
        {
            sleep(2)
            return
        }
        
        // Save the peripheral instance and connect to it
        mitsBeanPeripheral = peripheral
        
        // Set delegate to self for callbacks
        peripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral)
    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        DebugLogger.log("Connected to MITS Bean with UUID: \(peripheral.identifier.uuidString)", .INFO)
        updateConnectionStatus(.Connected)

        peripheral.discoverServices([mitsUUID!])
        messageAssembler = MessageAssembler()
        centralManager.scanForPeripherals(withServices: [mitsUUID!])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
    {
        updateConnectionStatus(.Disconnected)
    }
    
    // MARK:- CBPeripheralDelegate Functions
    
    // Handles Services Discovery
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        guard let services = peripheral.services else { return }
        for service in services
        {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    // Handles Characteristics Discovery
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics
        {
            // Set notifications on
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    
    // Called by Asynchronous Read
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        
        // TODO: Find the right characteristic uuid for Bean
        if (characteristic.value != nil)
        {
            let currentPacket = GattPacket(withData: characteristic.value!)
            let serialMessage = messageAssembler!.processPacket(currentPacket)
            if let serialMessageString = serialMessage?.stringValue()
            {
                // Try to Parse Flex Values
                if let flexValsJSON = serialMessageString.toJSON() as? JSONDictionary
                {
                    // Convert and update the flex values
                    if (!validateFlexValsJson(flexValsJSON))
                    {
                        DebugLogger.log("Could not validate flex vals: \(flexValsJSON)", .ERROR)
                        return
                    }
                    
                    // Update the flex values
                    let flexVals = convertJSONDictionary(flexValsJSON)
                    DebugLogger.log("\(String(describing: flexVals))", .SILLY)
                    updateFlexValues(flexVals, flexCallback)
                }
                else
                {
                    DebugLogger.log("Parsing error: \(serialMessageString)", .ERROR)
                }
            }
        }
    }
    
    // MARK:- Private Functions
    
    // Called whenever a new flex value is received
    private func updateFlexValues(_ newFlexVals: FlexValuesDictionary, _ flexCallback: FlexCallbackFunction?)
    {
        if (flexCallback != nil)
        {
            flexCallback!(newFlexVals)
        }
        else
        {
            DebugLogger.log("No Flex callback set", .ERROR)
        }
    }
    
    private func updateImuValues(_ newImuVals: FlexValuesDictionary)
    {
        if let callback = imuCallback
        {
            callback(newImuVals)
        }
        else
        {
            DebugLogger.log("No IMU callback set", .INFO)
        }
    }
    
    var lastTime: UInt64 = 0
    
    // Helper Debugging Function to print time
    private func printDate(string: String)
    {
        var info = mach_timebase_info()
        guard mach_timebase_info(&info) == KERN_SUCCESS else { return }
        let currentTime = mach_absolute_time()
        let nanos = currentTime * UInt64(info.numer) / UInt64(info.denom)
        print("time: \(nanos)")
        print("difference: \(nanos - lastTime)")
        lastTime = nanos
    }
    
    // MARK:- Public Functions
    
    func setUUIDsToLookFor(advertising advertisingUUID: CBUUID, device deviceUUID: UUID)
    {
        mitsUUID = advertisingUUID
        beanUUID = UUID(uuidString: deviceUUID.uuidString)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}

extension String
{
    // converts a string to JSON
    func toJSON() -> Any?
    {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
