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
            setPercussionMode()
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
//        setSustain(9, 0)
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
            //stopPianoChord(currentPianoSign)
        }
    }
    
    func stopPianoChord(_ sign: FlexSign)
    {
        let chordNotes = FlexSignPianoChords[sign]!
        for note in chordNotes
        {
            endNote(note, MidiChannels.pianoChannel.rawValue)
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
        for i in 1...8
        {
            playNote(FlexStringNotes["finger\(i)"]!, STRING_NOTE_VELOCITY, MidiChannels.stringChannelStart.rawValue + uint8(i) - 1)
        }
        
    }
    
    func stopStringNotes()
    {
        for i in 1...8
        {
            turnAllNotesOff(MidiChannels.stringChannelStart.rawValue + uint8(i) - 1)
        }
    }
    
    public func refreshStringNotes()
    {
        stopStringNotes()
        startStringNotes()
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
        setInstrument(PercussionInstrumentLeft - 1, MidiChannels.drumChannelOne.rawValue)
        setInstrument(PercussionInstrumentRight - 1, MidiChannels.drumChannelTwo.rawValue)
    }
    
    func playDrum(_ note: UInt8, velocity: UInt8)
    {
        playNote(note, velocity, MidiChannels.drumChannelOne.rawValue)
    }
    
    func setPercussionMode()
    {
        btHandlerLeft.setFlexCallback(percussionModeFlexCallbackLeft(_:))
        btHandlerRight.setFlexCallback(percussionModeFlexCallbackRight(_:))
    }
    
    func evaluateSign(_ flexValues: [String: AnyObject?]) -> FlexSign
    {
        var evaluatedSign = FlexSign.four
        if (flexValues["f1"] as! Int) < BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.zero
        }
        else if (flexValues["f2"] as! Int) < BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.one
        }
        else if (flexValues["f3"] as! Int) < BENDING_THRESHOLD
        {
            evaluatedSign = FlexSign.two
        }
        else if (flexValues["f4"] as! Int) < BENDING_THRESHOLD + 25
        {
            evaluatedSign = FlexSign.three
        }
        
        return evaluatedSign
    }
    
    // Variables used to keep track of current drum situation
    private var leftDrumSign = FlexSign.zero
    private var rightDrumSign = FlexSign.zero
    private var leftDrumPlaying = false
    private var rightDrumPlaying = false
    
    func percussionModeFlexCallbackLeft(_ newFlexVal: [String: AnyObject?])
    {
        leftDrumSign = evaluateSign(newFlexVal)
        let xVal = newFlexVal["x"] as! Double
        
        // do drum stuff here
        if (xVal >= 0 && !leftDrumPlaying)
        {
            leftDrumPlaying = true
            playNote(PercussionNotesLeft[leftDrumSign]!, 90, MidiChannels.drumChannelOne.rawValue)
        }
        else if (xVal < -0.10)
        {
            leftDrumPlaying = false
        }
    }
    
    func percussionModeFlexCallbackRight(_ newFlexVal: [String: AnyObject?])
    {
        rightDrumSign = evaluateSign(newFlexVal)
        let xVal = newFlexVal["x"] as! Double
        // do drum stuff here
        
        if (xVal >= 0 && !rightDrumPlaying)
        {
            rightDrumPlaying = true
            playNote(PercussionNotesRight[rightDrumSign]!, 90, MidiChannels.drumChannelTwo.rawValue)
        }
        else if (xVal < -0.10)
        {
            rightDrumPlaying = false
        }
    }
    
    
}

