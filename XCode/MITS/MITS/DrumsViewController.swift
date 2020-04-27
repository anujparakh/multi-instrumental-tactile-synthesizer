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
    @IBAction func playDrumClicked(_ sender: Any)
    {
        (parent as! ViewController).playDrumClicked(sender)
    }
    
    @IBAction func drumClick(_ sender: Any)
    {
        (parent as! ViewController).playDrumClicked(sender)

    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}
