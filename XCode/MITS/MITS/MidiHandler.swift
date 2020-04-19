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
    // MARK: Constants
    let NUM_FINGERS = 2; // Constant storing number of fingers on each glove
    let BENDING_THRESHOLD = 850 // threshold for bending value (above this counts as BENT)
    
    // MARK: Private Member variables
    private var currentInstrument: Instrument!;
    private var currentMode: MitsMode!;
    private var btHandler = BTHandler()
    private var pianoModeCallback: ((FlexSign) -> Void)?
    
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
            setPianoMode()
            break
        default:
            break
        }
    }
    
    
    
    func stopCurrentPlaying()
    {
        // Stop all current instruments here
    }
    
    
    
    init ()
    {
        initializePortMidi()
//        initForStringsMode()
        initForPianoMode()
//        initForPercussionMode()
        
    }
    
    //
    // MARK: Piano Mode Functions
    //
    func initForPianoMode()
    {
        setInstrument(Instrument.piano.rawValue, 1)
    }
    
    func playPianoChord(_ noteNumber: FlexSign)
    {
        if (currentMode == .pianoMode)
        {
            // TEMPORARY CODE
            var note = StringNotes.finger5
            switch (noteNumber)
            {
            case .one:
                note = StringNotes.finger6
                break
            case .two:
                note = StringNotes.finger7
                break
            case .three:
                note = StringNotes.finger8
                break
            case .four:
                note = StringNotes.finger1
                break
            default:
                break
            }
            playNote(note.rawValue, 0x60, 1)
        }
    }
    
    func setPianoMode()
    {
        btHandler.setFlexCallback(pianoModeFlexCallback(_:))
    }
    
    func setPianoModeHandler(_ callback: @escaping (FlexSign)->Void)
    {
        pianoModeCallback = callback
    }
    
    func pianoModeFlexCallback(_ newFlexVal: [String: AnyObject?])
    {
        var evaluatedSign = FlexSign.four
        if (newFlexVal["f1"] as! Int) > BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.zero
        }
        else if (newFlexVal["f2"] as! Int) > BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.one
        }
        else if (newFlexVal["f3"] as! Int) > BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.two
        }
        else if (newFlexVal["f4"] as! Int) > BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.three
        }

        if (pianoModeCallback != nil)
        {
            pianoModeCallback!(evaluatedSign)
        }
    }
    
    //
    // MARK: Strings Mode Functions
    //
    
    func initForStringsMode()
    {
        for channelIndex in 0..<NUM_FINGERS
        {
            setInstrument(Instrument.strings.rawValue, UInt8(channelIndex))
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
        playNote(StringNotes.finger5.rawValue, 60, 0)
        playNote(StringNotes.finger6.rawValue, 60, 1)

    }
    
    func calculateVolume(forFlex flexValue: Int) -> UInt8
    {
        var newVolume = flexValue
        newVolume = 127 - (newVolume - (900 - 128))
        if (newVolume < 0)
        {
            newVolume = 0
        }
        else if (newVolume > 127)
        {
            newVolume = 127
        }
        
        return UInt8(newVolume)
    }
    
    func stringsFlexCallback(_ newFlexVal: [String: AnyObject?])
    {
        if (currentMode != .flexStringsMode)
        {
            // do nothing
            return
        }
        print("t = \(newFlexVal["t"] as! Int) \t f1: \(newFlexVal["f1"] as! Int)")
        
        // set the volume for each flex sensor
        for flexIndex in 0..<NUM_FINGERS
        {
            setVolume(calculateVolume(forFlex: newFlexVal["f\(flexIndex + 1)"] as! Int), UInt8(flexIndex))
        }
    }
    
}
