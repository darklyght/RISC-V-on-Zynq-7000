import math
with open ('triangle_lut.hex', 'w') as f:
    for i in range(0, 32768):
        if (i <= 32768 / 4):
            f.write('{:x}'.format(int((i/(32768/4)*2047.5+2048))) + "\n")
        elif (i <= 3 * 32768 / 4):
            f.write('{:x}'.format(int(4095 - ((i-(32768/4))/(32768/4)*2047.5))) + "\n")
        else:
            f.write('{:x}'.format(int(((i-(32768/4))/(32768/4)*2047.5-4095))) + "\n")
