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
    // MARK:- Constants
    let NUM_FINGERS = 4; // Constant storing number of fingers on each glove
    let BENDING_THRESHOLD = 600 // threshold for bending value (above this counts as BENT)
    let STRING_NOTE_VELOCITY = UInt8(60)
    
    // MARK:- Private Member variables
    private var currentInstrument: Instrument!;
    private var currentMode: MitsMode!;
    private var btHandlerLeft = BeanBTHandler()
    private var btHandlerRight = BeanBTHandler()
    private var pianoModeCallback: ((FlexSign) -> Void)?
    private var currentPianoSign: FlexSign!
    
    public var btLeftConnectionStatusCallback: ConnectionStatusCallbackFunction?
    {
        didSet {
            btHandlerLeft.connectionStatusCallback = {(_ status: ConnectionStatus) -> Void in
                if (self.btLeftConnectionStatusCallback != nil)
                {
                    self.btLeftConnectionStatusCallback!(status)
                }
            }
        }
    }
    
    public var btRightConnectionStatusCallback: ConnectionStatusCallbackFunction?
    {
        didSet {
            btHandlerRight.connectionStatusCallback = {(_ status: ConnectionStatus) -> Void in
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
        initializePortMidi()
        initForStringsMode()
        initForPianoMode()
        initForPercussionMode()
        btHandlerLeft.setUUIDsToLookFor(advertising: BTConstants.beanAdvertisingID, device: BTConstants.beanIDLeft)
        btHandlerRight.setUUIDsToLookFor(advertising: BTConstants.beanAdvertisingID, device: BTConstants.beanIDRight)

    }
    
    // MARK:- Calibration Related Functions
    //
    public func calibrateBentHand()
    {
        stopCurrentPlaying()
        
        btHandlerLeft.flexCallback = {(flexVals: FlexValuesDictionary) -> Void in
            for (finger, flexVal) in flexVals
            {
                GloveConstants.LEFT_FLEX_MIN [finger] = flexVal
            }
        }
        
        btHandlerRight.flexCallback = {(flexVals: FlexValuesDictionary) -> Void in
            for (finger, flexVal) in flexVals
            {
                GloveConstants.RIGHT_FLEX_MIN [finger] = flexVal
            }
        }
    }
    
    public func calibrateOpenHand()
    {
        stopCurrentPlaying()
        btHandlerLeft.flexCallback = { (flexVals: FlexValuesDictionary) -> Void in
            for (finger, flexVal) in flexVals
            {
                GloveConstants.LEFT_FLEX_MAX [finger] = flexVal
            }
        }
        
        btHandlerRight.flexCallback = { (flexVals: FlexValuesDictionary) -> Void in

            for (finger, flexVal) in flexVals
            {
                GloveConstants.RIGHT_FLEX_MAX [finger] = flexVal
            }
        }
    }
    
    public func endCalibration()
    {
        updateMode(currentMode)
        GloveConstants.calculateThresholdValues()
        GloveConstants.printCalibratedValues()
    }
    
    // MARK:- Piano Mode Functions
    
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
        btHandlerLeft.flexCallback = pianoModeFlexCallback(_:)
        btHandlerRight.flexCallback = pianoModeForceCallback(_:)
    }
    
    // sets the handler for piano mode
    func setPianoModeHandler(_ callback: @escaping (FlexSign)->Void)
    {
        pianoModeCallback = callback
    }
    
    // Called whenever flex value changes when in piano mode
    func pianoModeFlexCallback(_ newFlexVal: FlexValuesDictionary)
    {
        let evaluatedSign = evaluateSign(fromValues: newFlexVal, thresholdValues: GloveConstants.LEFT_FLEX_THRESHOLD)
        
        if (pianoModeCallback != nil)
        {
            pianoModeCallback!(evaluatedSign)
        }
        currentPianoSign = evaluatedSign
        DebugLogger.log("Current Sign: \(currentPianoSign.debugDescription)", .INFO)
    }
    
    func playPianoChordClick()
    {
        playPianoChord(currentPianoSign, velocity: 100)
    }
    
    private var justPlayed = false
    
    func pianoModeForceCallback(_ newFlexVal: FlexValuesDictionary)
    {
//        let forceValue = newFlexVal["fs"] as! Int
        let forceValue = 400 // TEMP
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
    
    // MARK:- Strings Mode Functions
    
    func initForStringsMode()
    {
        for finger in GloveFinger.allCases
        {
            setInstrument(Instrument.strings.rawValue, LEFT_STRING_MIDI_CHANNELS[finger]!)
            setInstrument(Instrument.strings.rawValue, RIGHT_STRING_MIDI_CHANNELS[finger]!)
        }
    }
    
    // Update MIDI to deal with strings mode
    func setStringsMode()
    {
        currentMode = MitsMode.flexStringsMode
        currentInstrument = .strings
        // initForStringsMode()
        
        btHandlerLeft.flexCallback  = (stringsFlexCallbackLeft(_:))
        btHandlerRight.flexCallback = (stringsFlexCallbackRight(_:))
        
        startStringNotes()
    }
    
    func startStringNotes()
    {
        for finger in GloveFinger.allCases
        {
            playNote(LeftFlexStringNotes[finger]!, STRING_NOTE_VELOCITY, LEFT_STRING_MIDI_CHANNELS[finger]!)
            playNote(RightFlexStringNotes[finger]!, STRING_NOTE_VELOCITY, RIGHT_STRING_MIDI_CHANNELS[finger]!)
        }
    }
    
    func stopStringNotes()
    {
        for finger in GloveFinger.allCases
        {
            turnAllNotesOff(LEFT_STRING_MIDI_CHANNELS[finger]!)
            turnAllNotesOff(RIGHT_STRING_MIDI_CHANNELS[finger]!)
        }
    }
    
    public func refreshStringNotes()
    {
        stopStringNotes()
        startStringNotes()
    }
    
    func stringsFlexCallbackLeft(_ newFlexVal: FlexValuesDictionary)
    {
        if (currentMode != .flexStringsMode)
        {
            return // Do nothing
        }
        
        // set the volume for each flex sensor
        for (finger, flexVal) in newFlexVal
        {
            setVolume(calculateVolumeLeft(for: finger, value: flexVal), LEFT_STRING_MIDI_CHANNELS[finger]!)
        }

    }
    
    func stringsFlexCallbackRight(_ newFlexVal: FlexValuesDictionary)
    {
        if (currentMode != .flexStringsMode)
        {
            return // Do nothing
        }
        
        // set the volume for each flex sensor
        for (finger, flexVal) in newFlexVal
        {
            setVolume(calculateVolumeRight(for: finger, value: flexVal), RIGHT_STRING_MIDI_CHANNELS[finger]!)
        }
    }
    
    // MARK:- Percussion Mode Functions
    
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
        btHandlerLeft.flexCallback = (percussionModeFlexCallbackLeft(_:))
        btHandlerRight.flexCallback = (percussionModeFlexCallbackRight(_:))
    }
    
    // Variables used to keep track of current drum situation
    private var leftDrumSign = FlexSign.zero
    private var rightDrumSign = FlexSign.zero
    private var leftDrumPlaying = false
    private var rightDrumPlaying = false
    
    func percussionModeFlexCallbackLeft(_ newFlexVal: FlexValuesDictionary)
    {
        leftDrumSign = evaluateSign(fromValues: newFlexVal, thresholdValues: GloveConstants.LEFT_FLEX_THRESHOLD)
//        let xVal = newFlexVal["x"] as! Double
        let xVal = 10.0 // TEMP
        
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
    
    func percussionModeFlexCallbackRight(_ newFlexVal: FlexValuesDictionary)
    {
        rightDrumSign = evaluateSign(fromValues: newFlexVal, thresholdValues: GloveConstants.RIGHT_FLEX_THRESHOLD)
//        let xVal = newFlexVal["x"] as! Double
        let xVal = 10.0 // TEMP

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

