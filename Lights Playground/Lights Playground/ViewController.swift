//
//  ViewController.swift
//  Lights Playground
//
//  Created by Anuj Parakh on 4/25/21.
//

import UIKit
import HomeKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let beanHandler = BeanBTHandler()
    private let homeManager = HMHomeManager()
    private var bulbCharacteristics: [LightControlType: [(String, HMCharacteristic)]] = [:]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupHomeManager()
        setupBeanHandler()
    }
    
    private func setupViews()
    {
        UISegmentedControl.appearance().setTitleTextAttributes(NSDictionary(objects: [UIFont.systemFont(ofSize: 18.0)], forKeys: [NSAttributedString.Key.font as NSCopying]) as? [NSAttributedString.Key : Any], for: UIControl.State.normal)
        
        graphView.layer.cornerRadius = 10
    }
    
    private func setupHomeManager()
    {
        homeManager.delegate = self
        bulbCharacteristics[.Brightness] = []
        bulbCharacteristics[.Hue] = []
        bulbCharacteristics[.Temperature] = []
    }
    
    private func setupBeanHandler()
    {
        statusLabel.numberOfLines = 0
        
        beanHandler.setUUIDsToLookFor(advertising: BTConstants.beanAdvertisingID, device: BTConstants.beanIDRight)
        beanHandler.connectionStatusCallback = {(_ status: ConnectionStatus) -> Void in
            self.statusLabel.text = status.rawValue
        }
        
        beanHandler.flexCallback = { (_ flexVals: FlexValuesDictionary) -> Void in
            
            let controlSelected = LightControlType(rawValue: self.segmentedControl.selectedSegmentIndex)
            let toWrite = calculateControlValueRight(for: .Index, value: flexVals[.Index]!, controlType: controlSelected!)
            if self.bulbCharacteristics[controlSelected!] == nil
            {
                return
            }
            for (_, characteristic) in self.bulbCharacteristics[controlSelected!]!
            {
                characteristic.writeValue(toWrite, completionHandler: self.errorHandler)
            }
            
            self.valueLabel.text = "\(toWrite)"
            
        }
        
    }
    
    
    func errorHandler(error: Error?) -> Void
    {
        if let error = error
        {
            DebugLogger.log("Completion Handler error: \(error.localizedDescription)", .ERROR)
        }
    }
}

extension ViewController: HMHomeManagerDelegate
{
    private func saveAccessory(_ name: String, accessory: HMAccessory)
    {
        for service in accessory.services
        {
            if(service.serviceType == HMServiceTypeLightbulb)
            {
                for characteristic in service.characteristics
                {
                    if characteristic.characteristicType == HMCharacteristicTypeBrightness
                    {
                        bulbCharacteristics[.Brightness]?.append((name, characteristic))
                    }
                    
                    if characteristic.characteristicType == HMCharacteristicTypePowerState
                    {
                        
                    }
                    
                    if characteristic.characteristicType == HMCharacteristicTypeColorTemperature
                    {
                        bulbCharacteristics[.Temperature]?.append((name, characteristic)) // save it
                    }
                    
                    if characteristic.characteristicType == HMCharacteristicTypeHue
                    {
                        bulbCharacteristics[.Hue]?.append((name, characteristic)) // save it
                    }
                    
                }
                
            }
        }
    }
    
    private func saveAccessory(_ name: String, group: HMServiceGroup)
    {
        for service in group.services
        {
            if(service.serviceType == HMServiceTypeLightbulb)
            {
                for characteristic in service.characteristics
                {
                    if(characteristic.characteristicType == HMCharacteristicTypeBrightness)
                    {
                    }
                    
                    if(characteristic.characteristicType == HMCharacteristicTypePowerState)
                    {
                        
                    }
                    
                    if(characteristic.characteristicType == HMCharacteristicTypeColorTemperature)
                    {
                        
                    }
                    
                    
                }
                
            }
        }
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager)
    {
        for home in manager.homes
        {
            for accessory in home.accessories
            {
                if accessory.name == "Kitchen 1"
                {
                    saveAccessory(accessory.name, accessory: accessory)
                }
            }
            //            for group in home.serviceGroups
            //            {
            //                if group.name == "Lamp"
            //                {
            //                    saveAccessory("Lamp", group: group)
            //                }
            //            }
        }
    }
}
