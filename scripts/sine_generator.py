import math
def twos_comp(val, bits):
    if (val < 0):
        val = (1 << bits) + val
    return val

with open ('sine_lut.hex', 'w') as f:
    for i in range(0, 32768):
        f.write('{:x}'.format(twos_comp(int(math.sin(2*math.pi*i/32768)*2047), 12)) + "\n")
