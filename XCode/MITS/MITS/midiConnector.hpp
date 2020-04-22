//
//  midiConnector.hpp
//  MITS
//
//  Created by Anuj Parakh on 4/17/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

#ifndef midiConnector_hpp
#define midiConnector_hpp

#include <stdint.h>

#if __cplusplus
extern "C" {
#endif

void initializePortMidi();
int isMidiInitialized();
void setInstrument(uint8_t instrumentCode, uint8_t channel);
void playNote(uint8_t note, uint8_t velocity, uint8_t channel);
void endNote(uint8_t note, uint8_t channel);
void setVolume(uint8_t volume, uint8_t channel);
void setSustain(uint8_t sustainValue, uint8_t channel);

#ifdef __cplusplus
}
#endif
#endif
