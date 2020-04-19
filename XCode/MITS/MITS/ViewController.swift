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
    @IBOutlet weak var chordLabel: NSTextField!
    
    var midiHandler = MidiHandler()
    var currentChord = FlexSign.zero
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
        setupMidiHandler()
        currentMode = MitsMode.pianoMode
    }
    
    func setupMidiHandler()
    {
        midiHandler.setPianoModeHandler(fingerSignUpdated(_:))
    }
    
    func fingerSignUpdated(_ newSign: FlexSign)
    {
        chordLabel.stringValue = newSign.rawValue
        currentChord = newSign
    }
    
    
    @IBAction func playChordClicked(_ sender: Any)
    {
        midiHandler.playPianoChord(currentChord)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

