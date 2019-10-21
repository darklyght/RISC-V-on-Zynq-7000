"""
This script converts a raw square wave signal from a Verilog simulation into a .wav audio file for playback.

Usage: python scripts/audio_from_sim.py sim/build/output.txt

This script will generate a file named output.wav that can be played using the 'play binary'
Playback: play output.wav
"""

import wave
import random
import struct
import sys

output_wav = wave.open('output.wav', 'w')
output_wav.setparams((2, 2, 44100, 0, 'NONE', 'not compressed'))

values = []

filepath = sys.argv[1]
with open(filepath, 'r') as samples_file:
    data = samples_file.read()

for note in data:
    value = 0
    if (note == '0'):
        value = -20000
    elif (note == '1'):
        value = 20000
    else:
        continue
    packed_value = struct.pack('h', value)
    values.append(packed_value)
    values.append(packed_value)

value_str = ''.join(values)
output_wav.writeframes(value_str)
output_wav.close()
sys.exit(0)
