//
//  midiConnector.cpp
//  MITS
//
//  Created by Anuj Parakh on 4/17/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

#include <unistd.h>
#include <string>
#include <iostream>
#include <iomanip>
#include "portmidi.h"
#include "midiConnector.hpp"

// Macro to construct a MIDI message
#define MIDIMessage(status, channel, data1, data2) (uint32_t)(((data2 & 0x7f) << 16) | ((data1 & 0x7f) << 8) | ((status & 0xf0) | (channel & 0x0f)))
#define MIDI_NOTE_ON 0x90
#define MIDI_NOTE_OFF 0x80
#define MIDI_CONTROL_CHANGE 0xb0
#define MIDI_PROGRAM_CHANGE 0xc0
#define MIDI_CC_VOLUME 0x07


using namespace std;

// Constants
const string midiDeviceName = "IAC Driver Bus 1";

// Globals
PortMidiStream *midiDeviceStream = nullptr;

// Called to initialize portmidi
void initializePortMidi()
{
    // Find the midi device
    Pm_Initialize();
    PmDeviceID deviceIdToUse = -1;
    for (PmDeviceID deviceId = 0; deviceId < Pm_CountDevices(); ++deviceId)
    {
        auto deviceInfo = Pm_GetDeviceInfo(deviceId);
        if (midiDeviceName == deviceInfo->name && deviceInfo->output)
        {
            deviceIdToUse = deviceId;
            break;
        }
    }
    
    // Try to open the stream
    auto openResult = Pm_OpenOutput(&midiDeviceStream, deviceIdToUse, nullptr, 0, nullptr, nullptr, 0);
    if (openResult != pmNoError)
    {
        cout << "PROBLEM : " << openResult << endl;
        return;
    }
}

// Check if Midi has already been initialized
int isMidiInitialized()
{
    return midiDeviceStream != nullptr;
}

//
// Functionalities!
//

void printInstruction(uint32_t instruction)
{
//    cout << "Sending inst: " << hex << "0x" << instruction << endl;
}

// Set MIDI Instrument
void setInstrument(uint8_t instrumentCode, uint8_t channel)
{
    // Construct the instruction

    const uint32_t instrumentInstruction(MIDIMessage(MIDI_PROGRAM_CHANGE, channel, instrumentCode, 0x00));
    Pm_WriteShort(midiDeviceStream, 0, instrumentInstruction);
}

// Play Note with Velocity
void playNote(uint8_t note, uint8_t velocity, uint8_t channel)
{
    // Construct the instruction
    
    const uint32_t noteOnInstruction(MIDIMessage(MIDI_NOTE_ON, channel, note, velocity));
    Pm_WriteShort(midiDeviceStream, 0, noteOnInstruction);
}

void setVolume(uint8_t volume, uint8_t channel)
{
    // Construct the instruction
    
    const uint32_t volumeInstruction (MIDIMessage(MIDI_CONTROL_CHANGE, channel, MIDI_CC_VOLUME, volume));
    printInstruction(volumeInstruction);
    Pm_WriteShort(midiDeviceStream, 0, volumeInstruction);
}

// End Note
void endNote(uint8_t note, uint8_t channel)
{
    // Construct the instruction
 
    const uint32_t noteOffInstruction(MIDIMessage(MIDI_NOTE_OFF, channel, note, 0x00));

    Pm_WriteShort(midiDeviceStream, 0, noteOffInstruction);
}
