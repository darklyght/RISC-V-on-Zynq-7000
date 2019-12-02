#!/usr/bin/env python3
# Requires: pip install spfpm

from FixedPoint import FXfamily, FXnum
from enum import Enum, auto
import numpy as np
import sys

class WaveType(Enum):
    SINE = auto()
    SQUARE = auto()
    TRIANGLE = auto()
    SAWTOOTH = auto()

class NCO:
    def __init__(self, fsamp: float, interpolate: bool) -> None:
        self.fsamp = fsamp
        self.interpolate = interpolate
        self.output_type = FXfamily(n_bits=16, n_intbits=4)
        self.phase_acc = 0 # type: int
        self.N = 24
        self.M = 8
        self.lut_entries = 2**self.M

        self.sine_lut_float = [np.sin(i * 2*np.pi / self.lut_entries) for i in range(self.lut_entries)]
        self.sine_lut_fixed = [FXnum(x, family=self.output_type) for x in self.sine_lut_float]

        self.square_lut_fixed = [FXnum(1, family=self.output_type) for x in range(int(self.lut_entries/2))] + \
            [FXnum(-1, family=self.output_type) for x in range(int(self.lut_entries/2))]

        self.triangle_lut_float = [np.max(1 - np.abs(x)) for x in np.linspace(-1, 1, self.lut_entries)]
        self.triangle_lut_float = [x*2 - 1 for x in self.triangle_lut_float] # scale to range from -1 to 1
        self.triangle_lut_fixed = [FXnum(x, family=self.output_type) for x in self.triangle_lut_float]

        self.sawtooth_lut_float = [x - np.floor(x) for x in np.linspace(0, 1-1e-16, self.lut_entries)]
        self.sawtooth_lut_float = [x*2 - 1 for x in self.sawtooth_lut_float] # scaling again
        self.sawtooth_lut_fixed = [FXnum(x, family=self.output_type) for x in self.sawtooth_lut_float]

    def next_sample(self, fcw: int, wave_type) -> FXnum:
        lut_index = (self.phase_acc >> (self.N - self.M)) & int('1'*self.M, 2) # take MSB M bits of phase_acc
        if self.interpolate is False:
            sample = self.sine_lut_fixed[lut_index]
        else:
            samp1 = self.sine_lut_fixed[lut_index]
            samp2 = self.sine_lut_fixed[(lut_index + 1) % self.lut_entries]
            residual = self.phase_acc & int('1'*(self.N - self.M), 2) # take LSB (N-M) bits of phase_acc
            residual = FXnum(residual/(2**(self.N - self.M)), family=self.output_type) # Cast residual as fixed point
            diff = samp2 - samp1
            sample = samp1 + residual*diff

        self.phase_acc = self.phase_acc + fcw
        self.phase_acc = self.phase_acc % 2**self.N # overflow on N bits
        return sample

    def next_sample_f(self, freq: float, wave_type) -> FXnum:
        phase_increment = (freq / self.fsamp) * 2**self.N
        return self.next_sample(int(round(phase_increment)), 0)

if __name__ == "__main__":
    fsig = 880
    fsamp = 30e3
    nco = NCO(fsamp, interpolate = True)
    num_periods = 5
    num_samples = int(np.ceil(fsamp / fsig)) * num_periods
    nco_samples = [nco.next_sample_f(fsig, 0) for n in range(num_samples)]
    nco_samples_float = [float(x) for x in nco_samples]
    ideal_samples = [np.sin(2*np.pi*fsig*n/fsamp) for n in range(num_samples)]

    ## Plot NCO vs ideal samples
    #import matplotlib.pyplot as plt
    #fig, ax = plt.subplots(2, 1)
    #ax[0].plot(nco_samples_float, '*')
    #ax[0].plot(ideal_samples, '*')
    #ax[0].legend(['NCO Samples', 'Ideal Samples'])
    #ax[1].plot(np.abs(np.array(nco_samples_float) - np.array(ideal_samples)))
    #ax[1].legend(['NCO Error'])
    #plt.show()

    ## Dump LUTs
    #sine_lut = [x.toBinaryString() for x in nco.sine_lut_fixed]
    #for val in sine_lut:
    #    print('{}'.format(val.replace('.', '')))

    # sine float casted values
    #sine_lut = [float(x) for x in nco.sine_lut_fixed]
    #print(sine_lut)

    #square_lut = [x.toBinaryString() for x in nco.square_lut_fixed]
    #for val in square_lut:
    #    print('{}'.format(val.replace('.', '')))

    #triangle_lut = [x.toBinaryString() for x in nco.triangle_lut_fixed]
    #for val in triangle_lut:
    #    print('{}'.format(val.replace('.', '')))

    #saw_lut = [x.toBinaryString() for x in nco.sawtooth_lut_fixed]
    #for val in saw_lut:
    #    print('{}'.format(val.replace('.', '')))
