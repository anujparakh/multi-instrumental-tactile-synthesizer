//
//  ViewController.swift
//  TestBLE
//
//  Created by Anuj Parakh on 2/23/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{
    private var handler: BTHandler!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        handler = BTHandler()
    }
    
    override var representedObject: Any?
        {
        didSet
        {
            // Update the view, if already loaded.
        }
    }
    
    
}

