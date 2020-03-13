//
//  ViewController.swift
//  TestMIDI
//
//  Created by Anuj Parakh on 3/12/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{

    @IBOutlet weak var noteField: NSTextField!
    
    @IBAction func noteonClicked(_ sender: NSButton)
    {
        print("playing note")
        let note = noteField.intValue
        playNote(uint8(note), 0x40, 0x1)
    }
    
    @IBAction func noteOffClicked(_ sender: NSButton)
    {
        endNote(0x3c, 0x1)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initializePortMidi()
        setInstrument(Instrument.guitar.rawValue, 1)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

