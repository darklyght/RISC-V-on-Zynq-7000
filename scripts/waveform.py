import numpy as np
from scipy import signal
import matplotlib.pyplot as plt

# This function generates the waveform for sine, square and sawtooth
# 440Hz wave sampled at 44.1KHz
def waveform(wave_type):
	
	x = np.linspace(-np.pi, np.pi, 101)

	# sine
	if (wave_type == 1):
		out_wave = np.sin(x)

	# square
	elif (wave_type == 2):
		out_wave = signal.square(x)

	#sawtooth
	elif (wave_type == 3):
		out_wave = signal.sawtooth(x)

	else:
		out_wave = 0 * x

	return out_wave


# This function converts a number to fixed point representation of a certain 
# resolution. The numbers are limited to between -1 and 1, so there is no 
# integer but only fractions.
def frac_to_binary(number, res):
	
	bin_rep = "0"
	if (number < 0):
		bin_rep = "1"

	number = abs(number)

	for i in range(res-1):
		if (number >= 1/(2**(i+1))):
			number = number - 1/(2**(i+1))
			bin_rep = bin_rep + "1"
		else:
			bin_rep = bin_rep + "0"

	return  bin_rep


def write_to_file(res, wave_type):

	wave = waveform(wave_type)

	f = open('wave.txt','w')

	for sig in wave: 
		value = frac_to_binary(sig, res)
		f.write(value+"\n")

	f.close()

write_to_file(9, 3)



