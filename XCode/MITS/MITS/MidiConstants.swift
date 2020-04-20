//
//  MidiConstants.swift
//  MITS
//
//  Created by Anuj Parakh on 4/17/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Foundation

// Stores codes of all the instruments
enum Instrument: uint8
{
    case guitar = 0x19
    case strings = 0x11
    case piano = 0x01
    // Add instruments here
}

enum MitsMode: String
{
    case flexStringsMode = "Strings"
    case percussionMode = "Drums"
    case pianoMode = "Piano"
    // Add different possible modes here
}

enum MidiChannels: UInt8
{
    case pianoChannel = 0
    case stringChannelStart = 1 // Needs 8 channels
    case stringChannelEnd = 8 // Needs 8 channels
    case drumChannelStart = 9 // Needs 4 channels
}


enum FlexSign: String
{
    case zero = "zero"
    case one = "one"
    case two = "two"
    case three = "three"
    case four = "four"
}

//enum PianoChords: uint8
//{
//
//}

// Stores the notes for each finger during String Mode
enum StringNotes: uint8
{
    case finger1 = 60 // middle C
    case finger2 = 67 // middle G
    case finger3 = 65 // middle F
    case finger4 = 69 // middle A
    case finger5 = 72 // +1 C
    case finger6 = 79 // +1 G
    case finger7 = 77 // +1 F
    case finger8 = 81 // +1 A
}
