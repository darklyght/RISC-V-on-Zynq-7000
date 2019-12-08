import math
def twos_comp(val, bits):
    if (val < 0):
        val = (1 << bits) + val
    return val

with open ('square_lut.hex', 'w') as f:
    for i in range(0, 256):
        if ((i + 0.5) <= 256):
            f.write('{:x}'.format(twos_comp(65536, 21)) + "\n")
        else:
            f.write('{:x}'.format(twos_comp(-65536, 21)) + "\n")
