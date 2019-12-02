import math

def twos_comp(val, bits):
    if (val < 0):
        val = (1 << bits) + val
    return val


with open ('triangle_lut.hex', 'w') as f:
    for i in range(0, 256):
        if (i <= 256 / 4):
            f.write('{:b}'.format(twos_comp(int((i/(256/4)*65536)), 21)).rjust(21, '0') + "\n")
        elif (i <= 3 * 256 / 4):
            f.write('{:b}'.format(twos_comp(int(65536 - ((i-(256/4))/(256/2)*65536-65536/2)), 21)).rjust(21, '0') + "\n")
        else:
            f.write('{:b}'.format(twos_comp(int(((i-(256/4))/(256/4)*65536-65536)), 21)).rjust(21, '0') + "\n")
