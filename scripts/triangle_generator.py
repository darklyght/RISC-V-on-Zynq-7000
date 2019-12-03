import math

def twos_comp(val, bits):
    if (val < 0):
        val = (1 << bits) + val
    return val


with open ('triangle_lut.hex', 'w') as f:
    for i in range(0, 256):
        print(int((i/256*65536)))
        f.write('{:x}'.format(twos_comp(int((i/256*65536)), 21)) + "\n")
