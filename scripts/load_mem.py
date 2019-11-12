import os
import serial
import sys
import time

if os.name == 'nt':
    print('Windows machine!')
    ser = serial.Serial()
    ser.baudrate = 115200
    ser.port = 'COM11' # CHANGE THIS COM PORT
    ser.open()
else:
    print('Not windows machine!')
    ser = serial.Serial('/dev/ttyUSB0')
    ser.baudrate = 115200

addr = int(sys.argv[2], 16);

with open(sys.argv[1], "r") as file:
	line = file.readline()
	while line:
		s = 'sw ' + line.rstrip() + ' ' + format(addr, 'x') + '\r'
		for i in range(len(s)):
			print(ord(s[i]))
			ser.write(bytearray([ord(s[i])]))
			time.sleep(0.001)
		line = file.readline()
		addr = addr + 4
