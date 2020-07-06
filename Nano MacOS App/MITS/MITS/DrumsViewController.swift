//
//  DrumsViewController.swift
//  MITS
//
//  Created by Anuj Parakh on 4/19/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

class DrumsViewController:NSViewController
{
    
    @IBOutlet weak var HandsImage: NSImageView!
    
    @IBOutlet weak var leftDrumType: NSPopUpButton!
    @IBOutlet weak var rightDrumType: NSPopUpButton!
    
    @IBOutlet weak var leftZeroDrum: NSPopUpButton!
    @IBOutlet weak var leftOneDrum: NSPopUpButton!
    @IBOutlet weak var leftTwoDrum: NSPopUpButton!
    @IBOutlet weak var leftThreeDrum: NSPopUpButton!
    @IBOutlet weak var leftFourDrum: NSPopUpButton!
    
    @IBOutlet weak var rightZeroDrum: NSPopUpButton!
    @IBOutlet weak var rightOneDrum: NSPopUpButton!
    @IBOutlet weak var rightTwoDrum: NSPopUpButton!
    @IBOutlet weak var rightThreeDrum: NSPopUpButton!
    @IBOutlet weak var rightFourDrum: NSPopUpButton!
    
    
    @IBAction func drumTypeSelected(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            if sender == leftDrumType
            {
                parentController?.updateDrumCategory(sender.titleOfSelectedItem!, hand: "left")
            }
            else if sender == rightDrumType
            {
                parentController?.updateDrumCategory(sender.titleOfSelectedItem!, hand: "right")
            }
            

        }
    }
    
    @IBAction func drumCategorySelectedLeft(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateLeftDrumType(sender.titleOfSelectedItem!, sign: sender.identifier!.rawValue)
        }
    }
    
    @IBAction func drumCategorySelectedRight(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateRightDrumType(sender.titleOfSelectedItem!, sign: sender.identifier!.rawValue)
        }
    }
    
    
    
    func setupDefaultValues()
    {
        leftDrumType.removeAllItems()
        leftDrumType.addItems(withTitles: Array(DrumCategory.keys))
        leftDrumType.selectItem(withTitle: "Synth Drum")
        rightDrumType.removeAllItems()
        rightDrumType.addItems(withTitles: Array(DrumCategory.keys))
        rightDrumType.selectItem(withTitle: "Synth Drum")
        
        let listOfDrumOptions = [leftZeroDrum, leftOneDrum, leftTwoDrum, leftThreeDrum, leftFourDrum,
                                 rightZeroDrum, rightOneDrum, rightTwoDrum, rightThreeDrum, rightFourDrum]
        for drumOptionIndex in 0..<listOfDrumOptions.count
        {
            listOfDrumOptions[drumOptionIndex]?.removeAllItems()
            listOfDrumOptions[drumOptionIndex]?.addItems(withTitles: Array(DrumType.keys))
            listOfDrumOptions[drumOptionIndex]?.selectItem(withTitle: PercussionDefaultNotes[drumOptionIndex % 5])
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupDefaultValues()
    }
}
