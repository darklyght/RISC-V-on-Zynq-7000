from NCO import NCOType, output_type
from FixedPoint import FXfamily, FXnum

class Summer:
    def __init__(self, sine_shift: int, square_shift: int, triangle_shift: int, sawtooth_shift: int) -> None:
        self.shifts = [sine_shift, square_shift, triangle_shift, sawtooth_shift]

    def next_sample(self, nco_in: NCOType) -> FXnum:
        sample = 0
        for wave,shift in zip(nco_in, self.shifts):
            sample = sample + (wave >> shift)
        return sample

class Truncator:
    def __init__(self, global_gain: int) -> None:
        self.global_gain = global_gain

    def next_sample(self, samp_in: FXnum) -> int:
        samp_gained = samp_in >> self.global_gain
        sample_bin = samp_in.toBinaryString().replace('.', '')
        sample_bin_msbs = samp_bin[:12]
        print(sample_bin_msbs)
