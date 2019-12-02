import math
def twos_comp(val, bits):
    if (val < 0):
        val = (1 << bits) + val
    return val

with open ('sawtooth_lut.hex', 'w') as f:
    for i in range(0, 32768):
        if (i <= 32768 / 2):
            f.write('{:x}'.format(twos_comp(int((i/(32768/2)*2044)), 12)) + "\n")
        else:
            f.write('{:x}'.format(twos_comp(int((i/(32768/2)*2044-4088)), 12)) + "\n")
