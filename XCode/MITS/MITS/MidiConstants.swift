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
var FlexStringNotes: [String: uint8] =
[
    "finger1" : 60, // middle C
    "finger2" : 67, // middle G
    "finger3" : 65, // middle F
    "finger4" : 69, // middle A
    "finger5" : 72, // +1 C
    "finger6" : 79, // +1 G
    "finger7" : 77, // +1 F
    "finger8" : 81 // +1 A
]

var FlexSignPianoChords: [FlexSign: [uint8]] =
[
    FlexSign.zero: [59, 64, 67], // Em Chord
    FlexSign.one: [60, 64, 67], // C Chord
    FlexSign.two: [62, 66, 69], // G Chord
    FlexSign.three: [57, 60, 64], // Am Chord
    FlexSign.four: [60, 65, 69] // F Chord
]

let PianoChordsNames =
[
    "Middle C", "Middle Dm", "Middle D", "Middle Em", "Middle E", "Middle F", "Middle F#", "Middle G", "Middle Am", "Middle A", "Middle Bm", "Middle B"
]

// New Stuff

let StringNoteNames = ["Middle C", "Middle C#", "Middle D",
                       "Middle D#", "Middle E", "Middle F",
                       "Middle F#", "Middle G", "Middle G#",
                       "Middle A", "Middle A#", "Middle B"]

let StringNotes: [String: uint8] =
[
    "Middle C" : 60,
    "Middle C#" : 61,
    "Middle D" : 62,
    "Middle D#" : 63,
    "Middle E" : 64,
    "Middle F" : 65,
    "Middle F#" : 66,
    "Middle G" : 67,
    "Middle G#" : 68,
    "Middle A" : 69,
    "Middle A#" : 70,
    "Middle B" : 71,
]

let PianoChords: [String: [uint8]] =
[
    
//    // Interval -1
//    "Lower C" : [60-12*1, 64-12*1, 67-12*1],
//    "Lower Dm" : [62-12*1, 64-12*1, 68-12*1],
//    "Lower D" : [62-12*1, 65-12*1, 68-12*1],
//    "Lower Em" : [64-12*1, 67-12*1, 71-12*1],
//    "Lower E" : [64-12*1, 68-12*1, 71-12*1],
//    "Lower F" : [65-12*1, 69-12*1, 72-12*1],
//    "Lower F#" : [66-12*1, 70-12*1, 73-12*1],
//    "Lower G" : [66-12*1, 70-12*1, 73-12*1],
//    "Lower Am" : [69-12*1, 72-12*1, 76-12*1],
//    "Lower A" : [69-12*1, 73-12*1, 76-12*1],
//    "Lower Bm" : [71-12*1, 74-12*1, 78-12*1],
//    "Lower B" : [71-12*1, 75-12*1, 78-12*1],
    
    // Interval 0
    "Middle C" : [60, 64, 67],
    "Middle Dm" : [62, 64, 68],
    "Middle D" : [62, 65, 68],
    "Middle Em" : [64, 67, 71],
    "Middle E" : [64, 68, 71],
    "Middle F" : [65, 69, 72],
    "Middle F#" : [66, 70, 73],
    "Middle G" : [66, 70, 73],
    "Middle Am" : [69, 72, 76],
    "Middle A" : [69, 73, 76],
    "Middle Bm" : [71, 74, 78],
    "Middle B" : [71, 75, 78],
    
//    // Interval 1
//    "Upper C" : [60+12*1, 64+12*1, 67+12*1],
//    "Upper Dm" : [62+12*1, 64+12*1, 68+12*1],
//    "Upper D" : [62+12*1, 65+12*1, 68+12*1],
//    "Upper Em" : [64+12*1, 67+12*1, 71+12*1],
//    "Upper E" : [64+12*1, 68+12*1, 71+12*1],
//    "Upper F" : [65+12*1, 69+12*1, 72+12*1],
//    "Upper F#" : [66+12*1, 70+12*1, 73+12*1],
//    "Upper G" : [66+12*1, 70+12*1, 73+12*1],
//    "Upper Am" : [69+12*1, 72+12*1, 76+12*1],
//    "Upper A" : [69+12*1, 73+12*1, 76+12*1],
//    "Upper Bm" : [71+12*1, 74+12*1, 78+12*1],
//    "Upper B" : [71+12*1, 75+12*1, 78+12*1] // ,

    
]





