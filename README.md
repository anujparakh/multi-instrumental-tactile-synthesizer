# multi-instrumental-tactile-synthesizer

This repository contains all the code for the multi-instrumental-tactile-synthesizer (MITS) project. MITS is a pair of gloves that
can be used to create different kinds of music. They use Arduino Nano 33 BLEs to connect over bluetooth to a MacOS application
that sends MIDI signals to a Digital Audio Workstation (DAW) like Reaper to change instruments and play the notes as required.
The glove has flex sensors and a force sensor to implement all the features of the glove.

There are three main modes that the MITS support:

## Piano Mode

In this mode, the user can choose five chords using the left glove by making the hand signs of zero, one, two, three or four, and 
use the force sensor on the right glove to play the chosen chord on any surface with varying levels of pressure. The chords can
be mapped to any sign via the MacOS application interface.

## Strings Mode

The Strings Mode allows the user to have control over 8 different Strings instruments playing at the same time with different
notes. Curling or closing a finger will smoothly turn off the sound for each note, while uncurling will raise it. The notes
for each finger can be chosen using the MacOS application.

## Drums Mode

This mode utilizes the onboard IMU to give the user the ability to play drums. Since these gloves connect over bluetooth, you can walk
around and play different percussion instruments using each hand.
