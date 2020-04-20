//
//  PianoViewController.swift
//  MITS
//
//  Created by Anuj Parakh on 4/19/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

class PianoViewController:NSViewController
{
    
    
    @IBAction func playChordClicked(_ sender: Any)
    {
        (parent as! ViewController).playChordClicked(sender)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}
