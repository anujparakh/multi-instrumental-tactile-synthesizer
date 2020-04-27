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
    let NUM_FINGERS = 4; // Constant storing number of fingers on each glove
    let BENDING_THRESHOLD = 750 // threshold for bending value (above this counts as BENT)
    let STRING_NOTE_VELOCITY = UInt8(60)
    
    // MARK: Private Member variables
    private var currentInstrument: Instrument!;
    private var currentMode: MitsMode!;
    private var btHandlerLeft = BTHandler()
    private var btHandlerRight = BTHandler()
    private var pianoModeCallback: ((FlexSign) -> Void)?
    private var currentPianoSign: FlexSign!
    
    public var btLeftConnectionStatusCallback: ((String) -> Void)?
    {
        didSet {
            btHandlerLeft.connectionStatusCallback = {(_ status: String) -> Void in
                if (self.btLeftConnectionStatusCallback != nil)
                {
                    self.btLeftConnectionStatusCallback!(status)
                }
            }
        }
    }
    
    public var btRightConnectionStatusCallback: ((String) -> Void)?
    {
        didSet {
            btHandlerRight.connectionStatusCallback = {(_ status: String) -> Void in
                if (self.btRightConnectionStatusCallback != nil)
                {
                    self.btRightConnectionStatusCallback!(status)
                }
            }
        }
    }

    
    public func updateMode(_ newMode: MitsMode)
    {
        stopCurrentPlaying()

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
        stopStringNotes()
    }
    
    
    
    init ()
    {
        btHandlerLeft.setUUIDToLookFor(BTConstants.nanoIDLeft)
        btHandlerRight.setUUIDToLookFor(BTConstants.nanoIDRight)

        initializePortMidi()
        initForStringsMode()
        initForPianoMode()
        initForPercussionMode()
        
    }
    
    //
    // MARK: Piano Mode Functions
    //
    func initForPianoMode()
    {
        setInstrument(Instrument.piano.rawValue, MidiChannels.pianoChannel.rawValue)
        setSustain(0, 0)
        currentPianoSign = .two
    }
    
    func playPianoChord(_ noteNumber: FlexSign, velocity: UInt8)
    {
        if (currentMode == .pianoMode)
        {
            playChord(chord: FlexSignPianoChords[currentPianoSign]!, velocity)
        }
    }
    
    func playChord(chord chordNotes: [uint8],_ velocity: uint8)
    {
        for note in chordNotes
        {
            playNote(note, velocity, MidiChannels.pianoChannel.rawValue)
        }

    }
    
    func setPianoMode()
    {
        btHandlerLeft.setFlexCallback(pianoModeFlexCallback(_:))
        btHandlerRight.setFlexCallback(pianoModeForceCallback(_:))
    }
    
    // sets the handler for piano mode
    func setPianoModeHandler(_ callback: @escaping (FlexSign)->Void)
    {
        pianoModeCallback = callback
    }
    
    // Called whenever flex value changes when in piano mode
    func pianoModeFlexCallback(_ newFlexVal: [String: AnyObject?])
    {

        var evaluatedSign = FlexSign.four
        if (newFlexVal["f1"] as! Int) < BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.zero
        }
        else if (newFlexVal["f2"] as! Int) < BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.one
        }
        else if (newFlexVal["f3"] as! Int) < BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.two
        }
        else if (newFlexVal["f4"] as! Int) < BENDING_THRESHOLD + 25
        {
            evaluatedSign = FlexSign.three
        }

        if (pianoModeCallback != nil)
        {
            pianoModeCallback!(evaluatedSign)
        }
        currentPianoSign = evaluatedSign
    }
    
    private var justPlayed = false
    
    func pianoModeForceCallback(_ newFlexVal: [String: AnyObject?])
    {
        let forceValue = newFlexVal["fs"] as! Int
        if (forceValue > 500) && !justPlayed
        {
            playPianoChord(currentPianoSign, velocity: UInt8((forceValue / 8) - 1))
            justPlayed = true
        }
        else if (forceValue < 500)
        {
            justPlayed = false
        }
    }

    
    
    //
    // MARK: Strings Mode Functions
    //
    
    func initForStringsMode()
    {
        for channelIndex in MidiChannels.stringChannelStart.rawValue...MidiChannels.stringChannelEnd.rawValue
        {
            setInstrument(Instrument.strings.rawValue, channelIndex)
        }
    }
    
    // Update MIDI to deal with strings mode
    func setStringsMode()
    {
        currentMode = MitsMode.flexStringsMode
        currentInstrument = .strings
        // initForStringsMode()
        
        btHandlerLeft.setFlexCallback(stringsFlexCallbackLeft(_:))
        btHandlerRight.setFlexCallback(stringsFlexCallbackRight(_:))

        startStringNotes()
    }
    
    func startStringNotes()
    {
        playNote(StringNotes.finger1.rawValue, STRING_NOTE_VELOCITY, MidiChannels.stringChannelStart.rawValue)
        playNote(StringNotes.finger2.rawValue, STRING_NOTE_VELOCITY, MidiChannels.stringChannelStart.rawValue + 1)
        playNote(StringNotes.finger3.rawValue, STRING_NOTE_VELOCITY, MidiChannels.stringChannelStart.rawValue + 2)
        playNote(StringNotes.finger4.rawValue, STRING_NOTE_VELOCITY, MidiChannels.stringChannelStart.rawValue + 3)
        playNote(StringNotes.finger5.rawValue, STRING_NOTE_VELOCITY, MidiChannels.stringChannelStart.rawValue + 4)
        playNote(StringNotes.finger6.rawValue, STRING_NOTE_VELOCITY, MidiChannels.stringChannelStart.rawValue + 5)
        playNote(StringNotes.finger7.rawValue, STRING_NOTE_VELOCITY, MidiChannels.stringChannelStart.rawValue + 6)
        playNote(StringNotes.finger8.rawValue, STRING_NOTE_VELOCITY, MidiChannels.stringChannelStart.rawValue + 7)
    }
    
    func stopStringNotes()
    {
        endNote(StringNotes.finger1.rawValue, MidiChannels.stringChannelStart.rawValue)
        endNote(StringNotes.finger2.rawValue, MidiChannels.stringChannelStart.rawValue + 1)
        endNote(StringNotes.finger3.rawValue, MidiChannels.stringChannelStart.rawValue + 2)
        endNote(StringNotes.finger4.rawValue, MidiChannels.stringChannelStart.rawValue + 3)
        endNote(StringNotes.finger5.rawValue, MidiChannels.stringChannelStart.rawValue + 4)
        endNote(StringNotes.finger6.rawValue, MidiChannels.stringChannelStart.rawValue + 5)
        endNote(StringNotes.finger7.rawValue, MidiChannels.stringChannelStart.rawValue + 6)
        endNote(StringNotes.finger8.rawValue, MidiChannels.stringChannelStart.rawValue + 7)
    }
    
    func calculateVolume(forFlex flexValue: Int) -> UInt8
    {
        var newVolume = flexValue
        newVolume = newVolume - 673
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
    
    func stringsFlexCallbackLeft(_ newFlexVal: [String: AnyObject?])
    {
        if (currentMode != .flexStringsMode)
        {
            // do nothing
            return
        }        
        // set the volume for each flex sensor
        for flexIndex in 0..<NUM_FINGERS
        {
            setVolume(calculateVolume(forFlex: newFlexVal["f\(flexIndex + 1)"] as! Int), MidiChannels.stringChannelStart.rawValue + UInt8(flexIndex))
        }
    }
    
    func stringsFlexCallbackRight(_ newFlexVal: [String: AnyObject?])
    {
        if (currentMode != .flexStringsMode)
        {
            // do nothing
            return
        }
        // set the volume for each flex sensor
        for flexIndex in 0..<NUM_FINGERS
        {
            setVolume(calculateVolume(forFlex: newFlexVal["f\(flexIndex + 1)"] as! Int), MidiChannels.stringChannelStart.rawValue + UInt8(flexIndex) + 4)
        }
    }

    
    //
    // MARK: Percussion Mode Functions
    //
    
    func initForPercussionMode()
    {
        // set the instruments for percussion channels
    }
    
}
