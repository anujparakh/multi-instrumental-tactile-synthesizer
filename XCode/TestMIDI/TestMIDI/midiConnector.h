//
//  midiConnector.hpp
//  TestMIDI
//
//  Created by Anuj Parakh on 3/12/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

#ifndef midiConnector_h
#define midiConnector_h

#include <stdint.h>

#if __cplusplus
extern "C" {
#endif

void initializePortMidi();
int isMidiInitialized();
void setInstrument(uint8_t instrumentCode, uint8_t channel);
void playNote(uint8_t note, uint8_t velocity, uint8_t channel);
void endNote(uint8_t note, uint8_t channel);

#ifdef __cplusplus
}
#endif
#endif /* midiConnector_hpp */
