//
//  midiConnector.cpp
//  TestMIDI
//
//  Created by Anuj Parakh on 3/12/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

#include <unistd.h>
#include <string>
#include <iostream>
#include <iomanip>
#include "portmidi.h"
#include "midiConnector.h"


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

// Set MIDI Instrument
void setInstrument(uint8_t instrumentCode, uint8_t channel)
{
    // Construct the instruction
    uint32_t instrumentInstruction =  (instrumentCode << 8) + 0xc0 + channel;
    Pm_WriteShort(midiDeviceStream, 0, instrumentInstruction);
}

// Play Note with Velocity
void playNote(uint8_t note, uint8_t velocity, uint8_t channel)
{
    // Construct the instruction
    
    uint32_t noteOnInstruction = velocity << 16;
    noteOnInstruction += note << 8;
    noteOnInstruction += 0x90 + channel;
    cout << hex << "0x" << noteOnInstruction << endl;
    Pm_WriteShort(midiDeviceStream, 0, noteOnInstruction);
}

// End Note
void endNote(uint8_t note, uint8_t channel)
{
    // Construct the instruction
    uint32_t noteOffInstruction =  note << 8;
    noteOffInstruction += 0x80 + channel;
    Pm_WriteShort(midiDeviceStream, 0, noteOffInstruction);
}




