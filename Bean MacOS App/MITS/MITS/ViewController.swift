//
//  ViewController.swift
//  MITS
//
//  Created by Anuj Parakh on 3/12/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate
{
    @IBOutlet weak var pianoContainerView: NSView!
    @IBOutlet weak var stringsContainerView: NSView!
    @IBOutlet weak var drumsContainerView: NSView!
    @IBOutlet weak var modeSegmentedControl: NSSegmentedControl!
    @IBOutlet weak var leftStatusView: NSTextField!
    @IBOutlet weak var rightStatusView: NSTextField!

    private var pianoViewController: PianoViewController!
    private var drumsViewController: DrumsViewController!
    private var stringsViewController: StringsViewController!
    
    @IBAction func modeSegmentSelected(_ sender: NSSegmentedControl)
    {
        pianoContainerView.isHidden = true
        stringsContainerView.isHidden = true
        drumsContainerView.isHidden = true
        
        switch (sender.selectedSegment)
        {
        case 0:
            drumsContainerView.isHidden = false
            currentMode = MitsMode.percussionMode
            break
        case 1:
            stringsContainerView.isHidden = false
            currentMode = MitsMode.flexStringsMode
            break
        case 2:
            pianoContainerView.isHidden = false
            currentMode = MitsMode.pianoMode
            break
            
        default:
            break;
        }
    }
    
    private func showAlert(title: String, message: String, completionHandler: (((NSApplication.ModalResponse) -> Void))? = nil  )
    {
        let theAlert: NSAlert = NSAlert()

        theAlert.messageText = title
        theAlert.informativeText = message
        theAlert.addButton(withTitle: "Okay")
        theAlert.alertStyle = NSAlert.Style.informational

        let theWindow = NSApplication.shared.mainWindow!
        theAlert.beginSheetModal(for: theWindow, completionHandler: completionHandler)
    }

    @IBAction func calibrateClicked(_ sender: Any)
    {
        // Check if glove is actually connected
        if !leftStatusView.stringValue.contains("Connected")
        {
            showAlert(title: "Not Connected", message: "Connect a MITS glove to calibrate it!")
            return
        }
        
        // read next values and calibrate
        self.midiHandler.calibrateBentHand()
        
        // Calibrate bent hand
        showAlert(title: "Calibrate Bending", message: "Bend both gloves fully and then click Okay to calibrate values.", completionHandler: { (modalResponse: NSApplication.ModalResponse) -> Void in
            
            self.midiHandler.endCalibration()
            
            // read next values and calibrate
            self.midiHandler.calibrateOpenHand()

            // when finished, calibrate unbent hand
            self.showAlert(title: "Calibrate Flexing", message: "Unbend both gloves fully and click Okay to calibrate values.", completionHandler: { (modalResponse: NSApplication.ModalResponse) -> Void in
                
                self.midiHandler.endCalibration()
                // done calibrating!
                self.showAlert(title: "Done Calibrating!", message: "Value Calibration is Complete!")

            })
            
        })
            
    }
    
    @IBAction func sillyPrintingClicked(_ sender: NSMenuItem)
    {
        if DEBUG_LEVEL_TOGGLES[.SILLY]!
        {
            sender.state = NSControl.StateValue.off
            DEBUG_LEVEL_TOGGLES[.SILLY] = false
        }
        else
        {
            sender.state = NSControl.StateValue.on
            DEBUG_LEVEL_TOGGLES[.SILLY] = true
        }
    }
    
    
    var midiHandler = MidiHandler()
    var currentChord = FlexSign.zero
    var currentMode: MitsMode = MitsMode.flexStringsMode
    {
        didSet
        {
            midiHandler.updateMode(currentMode)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupMidiHandler()
        // String mode is the initial mode
        currentMode = MitsMode.pianoMode
        
    }
    
    func setupMidiHandler()
    {
        midiHandler.btLeftConnectionStatusCallback = {(_ status: String) -> Void in
            self.leftStatusView.stringValue = "Left: \(status)"
        }

        midiHandler.btRightConnectionStatusCallback = {(_ status: String) -> Void in
            self.rightStatusView.stringValue = "Right: \(status)"
        }

    }
    
    func playDrumClicked(_ sender: Any)
    {
        midiHandler.playDrum(49, velocity: 80)
    }
    
    func playChordClicked()
    {
        midiHandler.playPianoChordClick()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK:- WindowDelegate stuff
    
    override func viewDidAppear() {
           self.view.window?.delegate = self
       }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        switch segue.destinationController
        {
                
            case let pianoController as PianoViewController:
                self.pianoViewController = pianoController

            default:
                break
        }
    }
    
    func windowWillClose(_ notification: Notification)
    {
        midiHandler.stopCurrentPlaying()
    }
    
    // MARK:- PianoViewController Functions
    
    func updateChordForSign(sign theSign: FlexSign, chordName: String)
    {
        let chordParts = chordName.components(separatedBy: " ")
        
        FlexSignPianoChords[theSign] = PianoChords[chordParts[1]]!
        
        if chordParts[0] == "Upper"
        {
            for i in 0..<FlexSignPianoChords[theSign]!.count
            {
                FlexSignPianoChords[theSign]![i] += 12
            }
        }
        else if chordParts[0] == "Lower"
        {
            for i in 0..<FlexSignPianoChords[theSign]!.count
            {
                FlexSignPianoChords[theSign]![i] -= 12
            }
        }
    }
    
    // MARK:- StringViewController Functions
    func updateStringNoteForFinger(finger fingerString: String, note: String)
    {
        FlexStringNotes[fingerString] = StringNotes[note]!
        if (currentMode == MitsMode.flexStringsMode)
        {
            midiHandler.refreshStringNotes()
        }
    }
    
    // MARK:- DrumsViewController Functions
    func updateDrumCategory(_ newCategory: String, hand: String)
    {
        if (hand == "left")
        {
            PercussionInstrumentLeft = DrumCategory[newCategory]!
        }
        else if (hand == "right")
        {
            PercussionInstrumentRight = DrumCategory[newCategory]!
        }
        midiHandler.initForPercussionMode()
    }
    
    func updateLeftDrumType(_ newType: String, sign: String)
    {
        var flexSign = FlexSign.zero
        switch (sign)
        {
        case "zero":
            flexSign = .zero
        case "one":
            flexSign = .one
        case "two":
            flexSign = .two
        case "three":
            flexSign = .three
        case "four":
            flexSign = .four
        default:
            break
        }
        
        PercussionNotesLeft[flexSign] = DrumType[newType]
    }
    
    func updateRightDrumType(_ newType: String, sign: String)
    {
        var flexSign = FlexSign.zero
        switch (sign)
        {
        case "zero":
            flexSign = .zero
        case "one":
            flexSign = .one
        case "two":
            flexSign = .two
        case "three":
            flexSign = .three
        case "four":
            flexSign = .four
        default:
            break
        }
        
        PercussionNotesRight[flexSign] = DrumType[newType]
    }
}


