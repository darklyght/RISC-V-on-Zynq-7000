def twos_comp(val, bits):
    if (val < 0):
        val = (1 << bits) + val
    return val

arr = []
with open("waves_bp.txt", "r") as f:
    a = f.readline()
    while (a):
        a = float(a)
        a = a * (2 ** 11)
        print(a)
##        a = int(a)
##        a = twos_comp(a, 12)
##        a = '{0:012b}'.format(a)
##        arr.append(a)
        a = f.readline()
##
##with open("waves.bin", "w") as f:
##    for a in arr:
##        f.write(a + '\n')
