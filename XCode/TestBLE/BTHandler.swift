//
//  BTHandler.swift
//  TestBLE
//
//  Created by Anuj Parakh on 3/11/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import CoreBluetooth

class BTHandler: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate
{
    private var centralManager: CBCentralManager!
    private var mitsPeripheral: CBPeripheral!
    private var messageAssembler = MessageAssembler()
    
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
            // Scan for any peripherals
            centralManager.scanForPeripherals(withServices: [BTConstants.beanID])
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
        print("Connected to MITS Mk IV!")
        mitsPeripheral.discoverServices([BTConstants.beanID])
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
                print (serialMessage!.stringValue())
            }
            
        }
        
        switch characteristic.uuid
        {
        case BTConstants.imuCharacteristicID:
            let jsonString = String(data: characteristic.value!, encoding: .utf8)!
            parseValues(withJSONString: jsonString)

        default:
//            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
            break
        }
    }
    
    func parseValues(withJSONString jsonString: String)
    {
        print(jsonString)
    }
    
    override init()
    {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}

