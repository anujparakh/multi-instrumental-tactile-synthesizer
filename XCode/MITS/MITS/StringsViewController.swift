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
        
    }
}
