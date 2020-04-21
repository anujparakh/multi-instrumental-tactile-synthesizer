//
//  BTHandler.swift
//  MITS
//
//  Created by Anuj Parakh on 4/18/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation
import CoreBluetooth

class BTHandler: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate
{
    private var centralManager: CBCentralManager!
    private var mitsPeripheral: CBPeripheral!
    private var mitsUUID: CBUUID!
    private var flexCallback: (([String: AnyObject]) -> Void)?;
    
    public var connectionStatusCallback: ((String) -> Void)?
    
    private func updateConnectionStatus(_ status: String)
    {
        if (connectionStatusCallback != nil)
        {
            connectionStatusCallback!(status)
        }
        else
        {
            print(status)
        }
    }
    
    // Callback when central manager's state is updated
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch central.state
        {
            
        case .unknown:
            print("Central Manager's State is Unknown")
        case .resetting:
            print("Central Manager's State is Resetting")
        case .unsupported:
            print("BLE Unsupported")
        case .unauthorized:
            print("BLE Unauthorized")
        case .poweredOff:
            print("BLE powered off")
        case .poweredOn:
            print("BLE On and Scanning")
            updateConnectionStatus("Scanning")
            // Scan for any peripherals
            centralManager.scanForPeripherals(withServices: [mitsUUID])
        @unknown default:
            print ("Central Manager Don't know :(")
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
        print("Connected to MITS Mk. II!")
        updateConnectionStatus("Connected to MITS!")

        mitsPeripheral.discoverServices([mitsUUID])
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
        switch characteristic.uuid
        {
        case BTConstants.imuCharacteristicID:
            let jsonString = String(data: characteristic.value!, encoding: .utf8)!
            print(parseValues(withJSONString: jsonString))
        case BTConstants.flexCharacteristicID:
            let flexString = String(data: characteristic.value!, encoding: .utf8)!
            updateFlexValues(parseValues(withJSONString: flexString))

        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    // Parse JSON values and return a dictionary
    func parseValues(withJSONString jsonString: String) -> [String: AnyObject]
    {
        return (jsonString.toJSON() as! [String:AnyObject])
        
    }
    
    // Called whenever a new flex value is received
    func updateFlexValues(_ newFlexVals: [String: AnyObject])
    {
        if (flexCallback != nil)
        {
            flexCallback!(newFlexVals)
        }
        else
        {
            print("No Flex callback set")
        }
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
    
}

extension String
{
    // converts a string to JSON
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
