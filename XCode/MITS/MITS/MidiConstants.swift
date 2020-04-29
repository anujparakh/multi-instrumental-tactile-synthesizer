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

enum FlexSign: String
{
    case zero = "zero"
    case one = "one"
    case two = "two"
    case three = "three"
    case four = "four"
}


//
// MARK: Drum Constants
//
let DrumCategory: [String: uint8] =
[
    "Tinkle Bell" : 113,
    "Agogo" : 114,
    "Steel Drums" : 115,
    "Woodblock" : 116,
    "Taiko Drum" : 117,
    "Melodic Tom" : 118,
    "Synth Drum" : 119,
    "Reverse Cymbal" : 120,
]
let DrumType: [String: uint8] =
[
    "Acoustic Bass Drum" : 35,
    "Bass Drum 1" : 36,
    "Side Stick" : 37,
    "Acoustic Snare" : 38,
    "Hand Clap" : 39,
    "Electric Snare" : 40,
    "Low Floor Tom" : 41,
    "Closed Hi Hat" : 42,
    "High Floor Tom" : 43,
    "Pedal Hi-Hat" : 44,
    "Low Tom" : 45,
    "Open Hi-Hat" : 46,
    "Low-Mid Tom" : 47,
    "Hi-Mid Tom" : 48,
    "Crash Cymbal 1" : 49,
    "High Tom" : 50,
    "Ride Cymbal 1" : 51,
    "Chinese Cymbal" : 52,
    "Ride Bell" : 53,
    "Tambourine" : 54,
    "Splash Cymbal" : 55,
    "Cowbell" : 56,
    "Crash Cymbal 2" : 57,
    "Vibraslap" : 58,
    "Ride Cymbal 2" : 59,
    "Hi Bongo" : 60,
    "Low Bongo" : 61,
    "Mute Hi Conga" : 62,
    "Open Hi Conga" : 63,
    "Low Conga" : 64,
    "High Timbale" : 65,
    "Low Timbale" : 66,
    "High Agogo" : 67,
    "Low Agogo" : 68,
    "Cabasa" : 69,
    "Maracas" : 70,
    "Short Whistle" : 71,
    "Long Whistle" : 72,
    "Short Guiro" : 73,
    "Long Guiro" : 74,
    "Claves" : 75,
    "Hi Wood Block" : 76,
    "Low Wood Block" : 77,
    "Mute Cuica" : 78,
    "Open Cuica" : 79,
    "Mute Triangle" : 80,
    "Open Triangle" : 81,
]

var PercussionInstrumentLeft = DrumCategory["Synth Drum"]! // default
var PercussionInstrumentRight = DrumCategory["Synth Drum"]! // default

var PercussionNotesLeft: [FlexSign: uint8] =
[
    .zero: 36, // bass drum 1
    .one: 49, // crash cymbal,
    .two: 38, // acoustic snare
    .three: 46, // open hi-hat
    .four: 48 // high-mid tom
]

var PercussionNotesRight: [FlexSign: uint8] =
[
    .zero: 36, // bass drum 1
    .one: 49, // crash cymbal,
    .two: 38, // acoustic snare
    .three: 46, // open hi-hat
    .four: 48 // high-mid tom
]

let PercussionDefaultNotes = [
    "Bass Drum 1", "Crash Cymbal 1", "Acoustic Snare", "Open Hi-Hat", "Hi-Mid Tom"
]


//
// MARK: String Constants
//
let StringNoteNames = ["Middle C", "Middle C#", "Middle D",
                       "Middle D#", "Middle E", "Middle F",
                       "Middle F#", "Middle G", "Middle G#",
                       "Middle A", "Middle A#", "Middle B"]

// Default values in order (1 - 8)
let StringDefaultValues = ["Middle C", "Middle F", "Middle G", "Middle A",
                           "Middle D", "Middle E", "Middle B", "Middle C#"]

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
    "Middle B" : 71
]


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

//
// MARK: Piano Constants
//
let PianoChords: [String: [uint8]] =
[
    
    // All of these are middle chords
    "C" : [60, 64, 67],
    "Dm" : [62, 65, 69],
    "D" : [62, 66, 69],
    "Em" : [64, 67, 71],
    "E" : [64, 68, 71],
    "F" : [65, 69, 72],
    "F#" : [66, 70, 73],
    "G" : [67, 71, 74],
    "Am" : [69, 72, 76],
    "A" : [69, 73, 76],
    "Bm" : [71, 74, 78],
    "B" : [71, 75, 78],

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
    "C", "Dm", "D", "Em", "E", "F", "F#", "G", "Am", "A", "Bm", "B"
]





