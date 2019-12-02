import math
with open ('square_lut.hex', 'w') as f:
    for i in range(0, 32768):
        if (i <= 32768 / 2):
            f.write('{:x}'.format(int(4095)) + "\n")
        else:
            f.write('{:x}'.format(int(0)) + "\n")
