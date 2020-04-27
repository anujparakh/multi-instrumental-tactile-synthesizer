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
    case drumChannelOne = 9 // Needs 5 channels
    case drumChannelTwo = 10
    case drumChannelThree = 11
    case drumChannelFour = 12
    case drumChannelFive = 13
}

enum PercussionInstruments: UInt8
{
    case synthDrum = 119
}

let PercussionNotes: [FlexSign: uint8] =
[
    .zero: 36, // bass drum 1
    .one: 49, // crash cymbal,
    .two: 38, // acoustic snare
    .three: 46, // open hi-hat
    .four: 48 // high-mid tom
]

enum FlexSign: String
{
    case zero = "zero"
    case one = "one"
    case two = "two"
    case three = "three"
    case four = "four"
}

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

let FlexSignPianoChords: [FlexSign: [uint8]] =
[
    FlexSign.zero: [59, 64, 67], // Em Chord
    FlexSign.one: [60, 64, 67], // C Chord
    FlexSign.two: [62, 66, 69], // G Chord
    FlexSign.three: [57, 60, 64], // Am Chord
    FlexSign.four: [60, 65, 69] // F Chord
]

let PianoChords: [String: [uint8]] =
[
    // Interval -3
    "C_-3" : [60-12*3, 64-12*3, 67-12*3],
    "Dm_-3" : [62-12*3, 64-12*3, 68-12*3],
    "D_-3" : [62-12*3, 65-12*3, 68-12*3],
    "Em_-3" : [64-12*3, 67-12*3, 71-12*3],
    "E_-3" : [64-12*3, 68-12*3, 71-12*3],
    "F_-3" : [65-12*3, 69-12*3, 72-12*3],
    "F#_-3" : [66-12*3, 70-12*3, 73-12*3],
    "G_-3" : [66-12*3, 70-12*3, 73-12*3],
    "Am_-3" : [69-12*3, 72-12*3, 76-12*3],
    "A_-3" : [69-12*3, 73-12*3, 76-12*3],
    "Bm_-3" : [71-12*3, 74-12*3, 78-12*3],
    "Bm_-3" : [71-12*3, 75-12*3, 78-12*3],
    
    // Interval -2
    "C_-2" : [60-12*2, 64-12*2, 67-12*2],
    "Dm_-2" : [62-12*2, 64-12*2, 68-12*2],
    "D_-2" : [62-12*2, 65-12*2, 68-12*2],
    "Em_-2" : [64-12*2, 67-12*2, 71-12*2],
    "E_-2" : [64-12*2, 68-12*2, 71-12*2],
    "F_-2" : [65-12*2, 69-12*2, 72-12*2],
    "F#_-2" : [66-12*2, 70-12*2, 73-12*2],
    "G_-2" : [66-12*2, 70-12*2, 73-12*2],
    "Am_-2" : [69-12*2, 72-12*2, 76-12*2],
    "A_-2" : [69-12*2, 73-12*2, 76-12*2],
    "Bm_-2" : [71-12*2, 74-12*2, 78-12*2],
    "Bm_-2" : [71-12*2, 75-12*2, 78-12*2],
    
    
    // Interval -1
    "C_-1" : [60-12*1, 64-12*1, 67-12*1],
    "Dm_-1" : [62-12*1, 64-12*1, 68-12*1],
    "D_-1" : [62-12*1, 65-12*1, 68-12*1],
    "Em_-1" : [64-12*1, 67-12*1, 71-12*1],
    "E_-1" : [64-12*1, 68-12*1, 71-12*1],
    "F_-1" : [65-12*1, 69-12*1, 72-12*1],
    "F#_-1" : [66-12*1, 70-12*1, 73-12*1],
    "G_-1" : [66-12*1, 70-12*1, 73-12*1],
    "Am_-1" : [69-12*1, 72-12*1, 76-12*1],
    "A_-1" : [69-12*1, 73-12*1, 76-12*1],
    "Bm_-1" : [71-12*1, 74-12*1, 78-12*1],
    "Bm_-1" : [71-12*1, 75-12*1, 78-12*1],
    
    // Interval 0
    "C_0" : [60, 64, 67],
    "Dm_0" : [62, 64, 68],
    "D_0" : [62, 65, 68],
    "Em_0" : [64, 67, 71],
    "E_0" : [64, 68, 71],
    "F_0" : [65, 69, 72],
    "F#_0" : [66, 70, 73],
    "G_0" : [66, 70, 73],
    "Am_0" : [69, 72, 76],
    "A_0" : [69, 73, 76],
    "Bm_0" : [71, 74, 78],
    "Bm_0" : [71, 75, 78],
    
    // Interval 1
    "C_1" : [60+12*1, 64+12*1, 67+12*1],
    "Dm_1" : [62+12*1, 64+12*1, 68+12*1],
    "D_1" : [62+12*1, 65+12*1, 68+12*1],
    "Em_1" : [64+12*1, 67+12*1, 71+12*1],
    "E_1" : [64+12*1, 68+12*1, 71+12*1],
    "F_1" : [65+12*1, 69+12*1, 72+12*1],
    "F#_1" : [66+12*1, 70+12*1, 73+12*1],
    "G_1" : [66+12*1, 70+12*1, 73+12*1],
    "Am_1" : [69+12*1, 72+12*1, 76+12*1],
    "A_1" : [69+12*1, 73+12*1, 76+12*1],
    "Bm_1" : [71+12*1, 74+12*1, 78+12*1],
    "Bm_1" : [71+12*1, 75+12*1, 78+12*1],
    
    // Interval 2
    "C_2" : [60+12*2, 64+12*2, 67+12*2],
    "Dm_2" : [62+12*2, 64+12*2, 68+12*2],
    "D_2" : [62+12*2, 65+12*2, 68+12*2],
    "Em_2" : [64+12*2, 67+12*2, 71+12*2],
    "E_2" : [64+12*2, 68+12*2, 71+12*2],
    "F_2" : [65+12*2, 69+12*2, 72+12*2],
    "F#_2" : [66+12*2, 70+12*2, 73+12*2],
    "G_2" : [66+12*2, 70+12*2, 73+12*2],
    "Am_2" : [69+12*2, 72+12*2, 76+12*2],
    "A_2" : [69+12*2, 73+12*2, 76+12*2],
    "Bm_2" : [71+12*2, 74+12*2, 78+12*2],
    "Bm_2" : [71+12*2, 75+12*2, 78+12*2],
    
]



