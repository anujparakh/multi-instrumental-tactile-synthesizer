//
//  PianoViewController.swift
//  MITS
//
//  Created by Anuj Parakh on 4/19/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

class PianoViewController:NSViewController, NSComboBoxDataSource
{
    
    @IBOutlet weak var HandsImage: NSImageView!
    @IBOutlet weak var chordBox1: NSComboBox!
    @IBOutlet weak var chordBox2: NSComboBox!
    @IBOutlet weak var chordBox3: NSComboBox!
    @IBOutlet weak var chordBox4: NSComboBox!
    @IBOutlet weak var chordBox5: NSComboBox!
    
    private var chordBoxes: [NSComboBox] = []
    private var chordNames: [String] = []
    
    
    @IBAction func chordZeroChosen(_ sender: NSComboBox)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateChordForSign(sign: .zero, chordName: sender.stringValue)
        }
    }
    
    
    @IBAction func chordOneChosen(_ sender: NSComboBox)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateChordForSign(sign: .one, chordName: sender.stringValue)
        }

    }
    
    
    @IBAction func chordTwoChosen(_ sender: NSComboBox)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateChordForSign(sign: .two, chordName: sender.stringValue)
        }

    }
    
    
    @IBAction func chordThreeChosen(_ sender: NSComboBox)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateChordForSign(sign: .three, chordName: sender.stringValue)
        }

    }
    
    
    @IBAction func chordFourChosen(_ sender: NSComboBox)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateChordForSign(sign: .four, chordName: sender.stringValue)
        }
    }
    
    private func setDefaultChords()
    {
        // chord zero
        chordBox1.stringValue = "Middle Em"
        chordZeroChosen(chordBox1)
        
        // chord one
        chordBox2.stringValue = "Middle C"
        chordOneChosen(chordBox2)

        // chord two
        chordBox3.stringValue = "Middle G"
        chordTwoChosen(chordBox3)

        // chord three
        chordBox4.stringValue = "Middle F"
        chordThreeChosen(chordBox4)
        
        // chord four
        chordBox5.stringValue = "Middle Am"
        chordFourChosen(chordBox5)

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        chordBoxes.append(chordBox1)
        chordBoxes.append(chordBox2)
        chordBoxes.append(chordBox3)
        chordBoxes.append(chordBox4)
        chordBoxes.append(chordBox5)
        
        // Populate all the chord names
        for modifier in ["Lower ", "Middle ", "Upper "]
        {
            for chordName in PianoChordsNames
            {
                chordNames.append(modifier + chordName)
            }
        }
        
        for chordBox in chordBoxes
        {
            chordBox.usesDataSource = true
            chordBox.dataSource = self
        }
        
        setDefaultChords()

    }
    
    // Returns the number of items that the data source manages for the combo box
    func numberOfItems(in comboBox: NSComboBox) -> Int
    {
      // anArray is an Array variable containing the objects
      return chordNames.count
    }
        
    // Returns the object that corresponds to the item at the specified index in the combo box
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any?
    {
      return chordNames[index]
    }
}
