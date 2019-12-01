import math
with open ('sawtooth_lut.hex', 'w') as f:
    for i in range(0, 32768):
        if (i <= 32768 / 2):
            f.write('{:x}'.format(int((i/(32768/2)*2047.5+2048))) + "\n")
        else:
            f.write('{:x}'.format(int((i/(32768/2)*2047.5-2047.5))) + "\n")
