//
//  StringsViewController.swift
//  MITS
//
//  Created by Anuj Parakh on 4/19/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

class StringsViewController:NSViewController
{
    
    @IBOutlet weak var leftFinger1: NSPopUpButton!
    @IBOutlet weak var leftFinger2: NSPopUpButton!
    @IBOutlet weak var leftFinger3: NSPopUpButton!
    @IBOutlet weak var leftFinger4: NSPopUpButton!
    
    @IBOutlet weak var rightFinger1: NSPopUpButton!
    @IBOutlet weak var rightFinger2: NSPopUpButton!
    @IBOutlet weak var rightFinger3: NSPopUpButton!
    @IBOutlet weak var rightFinger4: NSPopUpButton!
    
    var fingerNoteButtons: [NSPopUpButton] = []
    
    @IBAction func leftFinger1Selected(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateStringNoteForFinger(finger: "finger1" , note: sender.titleOfSelectedItem!)
        }
    }
    
    @IBAction func leftFinger2Selected(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateStringNoteForFinger(finger: "finger2" , note: sender.titleOfSelectedItem!)
        }
    }
    
    @IBAction func leftFinger3Selected(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateStringNoteForFinger(finger: "finger3" , note: sender.titleOfSelectedItem!)
        }
    }
    
    @IBAction func leftFinger4Selected(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateStringNoteForFinger(finger: "finger4" , note: sender.titleOfSelectedItem!)
        }
    }
    
    @IBAction func rightFinger1Selected(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateStringNoteForFinger(finger: "finger5" , note: sender.titleOfSelectedItem!)
        }
    }
    
    @IBAction func rightFinger2Selected(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateStringNoteForFinger(finger: "finger6" , note: sender.titleOfSelectedItem!)
        }
    }
    
    @IBAction func rightFinger3Selected(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateStringNoteForFinger(finger: "finger7" , note: sender.titleOfSelectedItem!)
        }
    }
    
    @IBAction func rightFinger4Selected(_ sender: NSPopUpButton)
    {
        let parentController = self.parent as? ViewController
        if (parentController != nil)
        {
            parentController?.updateStringNoteForFinger(finger: "finger8" , note: sender.titleOfSelectedItem!)
        }
    }
    
    
    func setDefaultNoteValues()
    {
        leftFinger1.selectItem(withTitle: StringDefaultValues[0])
//        leftFinger1Selected(leftFinger1)
        
        leftFinger2.selectItem(withTitle: StringDefaultValues[1])
//        leftFinger2Selected(leftFinger2)
        
        leftFinger3.selectItem(withTitle: StringDefaultValues[2])
//        leftFinger3Selected(leftFinger3)

        leftFinger4.selectItem(withTitle: StringDefaultValues[3])
//        leftFinger4Selected(leftFinger4)

        rightFinger1.selectItem(withTitle: StringDefaultValues[4])
//        rightFinger1Selected(rightFinger1)

        rightFinger2.selectItem(withTitle: StringDefaultValues[5])
//        rightFinger2Selected(rightFinger2)

        rightFinger3.selectItem(withTitle: StringDefaultValues[6])
//        rightFinger3Selected(rightFinger3)

        rightFinger4.selectItem(withTitle: StringDefaultValues[7])
//        rightFinger4Selected(rightFinger4)
    }
    
    
    @IBOutlet weak var HandsImage: NSImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fingerNoteButtons = [leftFinger1, leftFinger2, leftFinger3, leftFinger4, rightFinger1, rightFinger2, rightFinger3, rightFinger4]
        print("test")
        for button in fingerNoteButtons
        {
            button.removeAllItems()
            button.addItems(withTitles: StringNoteNames)
        }
        
        setDefaultNoteValues()
        
    }
    
    
}
