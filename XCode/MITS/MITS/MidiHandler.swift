//
//  MidiHandler.swift
//  MITS
//
//  Created by Anuj Parakh on 4/17/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation

class MidiHandler
{
    var currentInstrument: Instrument!;
    var currentMode: MitsMode!;
    
    var btHandler = BTHandler()
    
    public func updateMode(_ newMode: MitsMode)
    {
        currentMode = newMode
        switch (currentMode)
        {
        case .flexStringsMode:
            setStringsMode()
            break
        case .percussionMode:
            // TODO
            break
        case .pianoMode:
            // TODO
            break
        default:
            break
        }
    }
    
    // Update MIDI to deal with strings mode
    func setStringsMode()
    {
        currentMode = MitsMode.flexStringsMode
        stopCurrentPlaying()
        currentInstrument = .strings
        
        btHandler.setFlexCallback(stringsFlexCallback(_:))
        startStringNotes()
    }
    
    func startStringNotes()
    {
        playNote(StringNotes.finger5.rawValue, 60, 1)
    }
    
    func stringsFlexCallback(_ newFlexVal: [String: AnyObject?])
    {
        if (currentMode != .flexStringsMode)
        {
            // do nothing
            return
        }
        print("t = \(newFlexVal["t"]!) \t f1: \(newFlexVal["f1"]!)")
        var newVelocity = newFlexVal["f1"] as! Int
        newVelocity = 127 - (newVelocity - (900 - 128))
        if (newVelocity < 0)
        {
            newVelocity = 0
        }
        else if (newVelocity > 127)
        {
            newVelocity = 127
        }
        print(newVelocity)
        let rightVelocity = UInt8(newVelocity)
        setVolume(rightVelocity, 1)
    }
    
    func stopCurrentPlaying()
    {
        // Stop all current instruments here
    }
    
    init ()
    {
        initializePortMidi()
        setInstrument(Instrument.strings.rawValue, 1)
        
    }
    
}
