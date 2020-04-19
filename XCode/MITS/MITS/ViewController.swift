//
//  ViewController.swift
//  MITS
//
//  Created by Anuj Parakh on 3/12/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{
    @IBOutlet weak var modeLabel: NSTextField!
    
    var midiHandler = MidiHandler()
    var currentMode: MitsMode = MitsMode.flexStringsMode
    {
        didSet {
            // called whenever the mode changes so update the mode label
            modeLabel.stringValue = currentMode.rawValue
            midiHandler.updateMode(currentMode)
            
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentMode = MitsMode.flexStringsMode
    }
    
    func updateMode()
    {
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

