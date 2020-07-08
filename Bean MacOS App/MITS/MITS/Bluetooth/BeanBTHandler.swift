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
    private var centralManager: CBCentralManager!
    private var mitsPeripheral: CBPeripheral!
    private var mitsUUID: CBUUID?
    private var flexCallback: (([String: AnyObject]) -> Void)?
    private var imuCallback: (([String: AnyObject]) -> Void)?
    
    private var messageAssembler = MessageAssembler()
    
    public var connectionStatusCallback: ((String) -> Void)?
    
    private func updateConnectionStatus(_ status: String)
    {
        if (connectionStatusCallback != nil)
        {
            connectionStatusCallback!(status)
        }
        else
        {
            debugLog(status, .INFO)
        }
    }
    
    // Callback when central manager's state is updated
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch central.state
        {
            
        case .unknown:
            debugLog("Central Manager's State is Unknown", .ERROR)
        case .resetting:
            debugLog("Central Manager's State is Resetting", .IMPORTANT)
        case .unsupported:
            debugLog("BLE Unsupported", .ERROR)
        case .unauthorized:
            debugLog("BLE Unauthorized", .ERROR)
        case .poweredOff:
            debugLog("BLE powered off", .ERROR)
        case .poweredOn:
            updateConnectionStatus("Scanning")
            // Scan for any peripherals
            if (mitsUUID != nil)
            {
                centralManager.scanForPeripherals(withServices: [mitsUUID!])
                debugLog("BLE On and Scanning", .IMPORTANT)
            }
        @unknown default:
            debugLog ("Central Manager Don't know :(", .ERROR)
        }
    }
    
    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        // Save the peripheral instance and connect to it
        mitsPeripheral = peripheral
        // Set delegate to self for callbacks
        mitsPeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(mitsPeripheral)
    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        debugLog("Connected to MITS Mk. II!", .INFO)
        updateConnectionStatus("Connected to MITS!")

        mitsPeripheral.discoverServices([mitsUUID!])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
    {
        updateConnectionStatus("Disconnected")
    }
    
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
            let serialMessage = messageAssembler.processPacket(currentPacket)
            if (serialMessage != nil)
            {
                // Parse Flex Values
                let flexString = serialMessage!.stringValue()
                let flexVals = (parseValues(withJSONString: flexString))
                if (flexVals != nil)
                {
                    // Update Flex Values here
                    debugLog("\(String(describing: flexVals))", .SILLY)
                    updateFlexValues(flexVals!)
                }
                else
                {
                    debugLog("Parsing error: \(flexString)", .ERROR)
                }
            }
            
           
        }
        
//        switch characteristic.uuid
//        {
//
//        case BTConstants.flexCharacteristicID:
//            let flexString = String(data: characteristic.value!, encoding: .utf8)!
//            updateFlexValues(parseValues(withJSONString: flexString))
//
//        default:
//            debugLog("Unhandled Characteristic UUID: \(characteristic.uuid)")
//        }
    }
    
    // Parse JSON values and return a dictionary
    func parseValues(withJSONString jsonString: String) -> [String: AnyObject]?
    {
        let toReturn = (jsonString.toJSON() as? [String:AnyObject])
        return toReturn
    }
    
    // Called whenever a new flex value is received
    func updateFlexValues(_ newFlexVals: [ String: AnyObject])
    {
        if (flexCallback != nil)
        {
            flexCallback!(newFlexVals)
        }
        else
        {
            debugLog("No Flex callback set", .ERROR)
        }
    }
    
    func updateImuValues(_ newImuVals: [String: AnyObject])
    {
        if (imuCallback != nil)
        {
            imuCallback!(newImuVals)
        }
        else
        {
//            debugLog("No IMU callback set")
        }
    }
    
    public func setImuCallback(_ doOnImu: @escaping ([String: AnyObject]) -> Void)
    {
        self.imuCallback = doOnImu
    }
    
    public func setFlexCallback(_ doOnFlex: @escaping ([String: AnyObject]) -> Void)
    {
        self.flexCallback = doOnFlex
    }
    
    override init()
    {
        super.init()
    }
    
    func setUUIDToLookFor(_ theUUID: CBUUID)
    {
        mitsUUID = theUUID
        centralManager = CBCentralManager(delegate: self, queue: nil)

    }
    
    var lastTime: UInt64 = 0
    
    func printDate(string: String) {
        var info = mach_timebase_info()
        guard mach_timebase_info(&info) == KERN_SUCCESS else { return }
        let currentTime = mach_absolute_time()
        let nanos = currentTime * UInt64(info.numer) / UInt64(info.denom)
        print("time: \(nanos)")
        print("difference: \(nanos - lastTime)")
        lastTime = nanos
    }
    
}

extension String
{
    // converts a string to JSON
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
