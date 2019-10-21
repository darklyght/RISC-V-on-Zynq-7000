import wave
import random
import struct
import sys
import math

generated_c_filepath = sys.argv[1]
memory_file = sys.argv[2]

with open(memory_file, 'r') as memory_data:
    data = memory_data.read()

data = data.split('\n')

c_file = open(generated_c_filepath, 'w')
c_file.write("#define MUSIC_LENGTH %d\n" % (len(data)))
c_file.write("static uint32_t music[%d] = {\n" % (len(data)))

for i, sample in enumerate(data):
    if i == len(data) - 1:
        c_file.write("\t%s" % (sample))
    else:    
        c_file.write("\t%s,\n" % (sample))

c_file.write("};")
c_file.close()
