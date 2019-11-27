import math
with open ('sine_lut.hex', 'w') as f:
    for i in range(0, 32768):
        f.write('{:x}'.format(int(math.sin(2*math.pi*i/32768)*2047.5+2048)) + "\n")
