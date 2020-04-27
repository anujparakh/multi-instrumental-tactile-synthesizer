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
//    case guitar = 0x19
    case strings = 0x11
    case piano = 0x19
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

/* enum PianoChords: uint8
{
    // Middle Chords
    case C_Interval_0 = [60, 64, 67]
    case Dm_Interval_0 = [62, 64, 68]
    case D_Interval_0 = [62, 65, 68]
    case Em_Interval_0 = [64, 67, 71]
    case E_Interval_0 = [64, 68, 71]
    case F_Interval_0 = [65, 69, 72]
    case F#_Interval_0 = [66, 70, 73]
    case G_Interval_0 = [66, 70, 73]
    case Am_Interval_0 = [69, 72, 76]
    case A_Interval_0 = [69, 73, 76]
    case Bm_Interval_0 = [71, 74, 78]
    case Bm_Interval_0 = [71, 75, 78]
    
} */

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
