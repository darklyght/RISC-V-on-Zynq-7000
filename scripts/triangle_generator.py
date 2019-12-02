import math

def twos_comp(val, bits):
    if (val < 0):
        val = (1 << bits) + val
    return val


with open ('triangle_lut.hex', 'w') as f:
    for i in range(0, 32768):
        if (i <= 32768 / 4):
            f.write('{:x}'.format(twos_comp(int((i/(32768/4)*2044)), 12)) + "\n")
        elif (i <= 3 * 32768 / 4):
            f.write('{:x}'.format(twos_comp(int(4095 - ((i-(32768/4))/(32768/4)*2044+2043)), 12)) + "\n")
        else:
            f.write('{:x}'.format(twos_comp(int(((i-(32768/4))/(32768/4)*2044-2043)), 12)) + "\n")
