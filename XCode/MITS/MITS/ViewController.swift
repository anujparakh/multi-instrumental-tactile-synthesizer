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

    var pianoViewController: PianoViewController!
    
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
        currentMode = MitsMode.flexStringsMode
        
    }
    
    func setupMidiHandler()
    {
        midiHandler.btLeftConnectionStatusCallback = {(_ status: String) -> Void in
            self.leftStatusView.stringValue = "Left: \(status)"
        }

        midiHandler.btRightConnectionStatusCallback = {(_ status: String) -> Void in
            self.rightStatusView.stringValue = "Right: \(status)"
        }
        
        midiHandler.setPianoModeHandler({ (_ newSign: FlexSign) -> Void in
            self.pianoViewController.chordLabel.stringValue = newSign.rawValue
        })

    }
    
    // Called by child view controller
    func playChordClicked(_ sender: Any)
    {
        midiHandler.playPianoChord(currentChord, velocity: 80)
    }
    
    func playDrumClicked(_ sender: Any)
    {
        midiHandler.playDrum(49, velocity: 80)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    //
    // MARK: WindowDelegate stuff
    //
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
}

