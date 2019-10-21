#include <stddef.h>
#include "uart.h"
#include "string.h"
#include "ascii.h"
#include "memory_map.h"

#define BUFFER_LEN 128

/**** HARDWARE FUNCTIONS ****/

extern volatile unsigned int
  uart_control,
  uart_rx,
  uart_tx,
  i2s_full,
  i2s_sample;

/**** OSCILLATOR ROUTINES ****/

static int attenuate_delta(int x, int fac) {
  int out = 0;
  while (fac) {
    if (fac & 1) out += x;
    x <<= 1;
    fac >>= 1;
  }
  return out >> 12;
}

static int dt_combine(int cur, int prv) {
  return (cur + cur + cur - prv) >> 1;
}

static void apply_decay(int *val, int shift) {
  int v = *val;
  v <<= 12;
  v -= v >> shift;
  v >>= 12;
  *val = v;
}

struct osc_state {
  int freqfac, maginit, decaycycles, decayshift;
  int vcos0, vcos, vsin0, vsin, zcross, cdecay;
};

static void osc_reset(struct osc_state *os, int freqfac, int maginit, int decaycycles, int decayshift) {
  os->freqfac = freqfac;
  os->maginit = maginit;
  os->decaycycles = decaycycles;
  os->decayshift = decayshift;
  os->vcos0 = maginit;
  os->vcos = maginit;
  os->vsin0 = 0;
  os->vsin = 0;
  os->zcross = 0;
  os->cdecay = decaycycles;
}

static void osc_cycle(struct osc_state *os) {
  // do magnitude adjustment
  if (--os->cdecay == 0) {
    os->cdecay = os->decaycycles;
    apply_decay(&os->maginit, os->decayshift);
    apply_decay(&os->vcos0, os->decayshift);
    apply_decay(&os->vcos, os->decayshift);
    apply_decay(&os->vsin0, os->decayshift);
    apply_decay(&os->vsin, os->decayshift);
  }
  // do phase shift
  int vcos = os->vcos;
  int vsin = os->vsin;
  int nvcos = vcos - attenuate_delta(dt_combine(vsin, os->vsin0), os->freqfac);
  int nvsin = vsin + attenuate_delta(dt_combine(vcos, os->vcos0), os->freqfac);
  os->vcos0 = vcos;
  os->vsin0 = vsin;
  int zcrocc = (vsin < 0 && nvsin >= 0);
  if (zcrocc && os->zcross == 15) {
    os->vcos = os->maginit;
    os->vsin = 0;
    os->zcross = 0;
  } else {
    os->vcos = nvcos;
    os->vsin = nvsin;
    os->zcross += zcrocc;
  }
}

/**** PROGRAM ROUTINES ****/

#define OS_COUNT (4)

int main() {
  struct osc_state oss[OS_COUNT];
  for (struct osc_state *os = &oss[0]; os < &oss[OS_COUNT]; os++)
  osc_reset(os, 0, 0, 1, 0);

  static const short ffs[128] = {
    ['Z'] = 70,
    ['S'] = 74,
    ['X'] = 79,
    ['D'] = 83,
    ['C'] = 88,
    ['V'] = 94,
    ['G'] = 99,
    ['B'] = 105,
    ['H'] = 111,
    ['N'] = 118,
    ['J'] = 125,
    ['M'] = 132,
    ['<'] = 140,

    ['z'] = 140,
    ['s'] = 149,
    ['x'] = 157,
    ['d'] = 167,
    ['c'] = 177,
    ['v'] = 187,
    ['g'] = 198,
    ['b'] = 210,
    ['h'] = 222,
    ['n'] = 236,
    ['j'] = 250,
    ['m'] = 264,
    [','] = 280,

    ['q'] = 280,
    ['2'] = 297,
    ['w'] = 317,
    ['3'] = 333,
    ['e'] = 352,
    ['r'] = 373,
    ['5'] = 395,
    ['t'] = 418,
    ['6'] = 443,
    ['y'] = 469,
    ['7'] = 497,
    ['u'] = 526,
    ['i'] = 557,

    ['Q'] = 557,
    ['@'] = 589,
    ['W'] = 624,
    ['#'] = 660,
    ['E'] = 699,
    ['R'] = 738,
    ['%'] = 781,
    ['T'] = 826,
    ['^'] = 974,
    ['Y'] = 924,
    ['&'] = 975,
    ['U'] = 1030,
    ['I'] = 1088,
  };

  struct osc_state *cur_os = &oss[0];
  int next_sample = 0;
  int8_t buffer[BUFFER_LEN];
  while (1) {
    if (uart_control & 0x02) {
      int c = uart_rx;
      if (c == '`') {
        return 0;
      }
      short ff = ffs[c];
      if (ff) {
        osc_reset(cur_os, ff, 0x60000, 48, 6);
        cur_os++;
        if (cur_os == &oss[OS_COUNT])
          cur_os = &oss[0];
      }
    }
    if (!i2s_full) {
      i2s_sample = next_sample;
      next_sample = 0;
      for (struct osc_state *os = &oss[0]; os < &oss[OS_COUNT]; os++) {
        next_sample += os->vsin;
        osc_cycle(os);
      }
      // TODO: Scale next_sample by volume since I2S won't do it for us. See
      // i2s_basic_test for an example.
      //
      // Bound samples to (signed) 24-bit.
      if (next_sample >= 0x800000) {
        next_sample = 0x7FFFFF;
      } else if (next_sample < -0x800000) {
        next_sample = -0x800000;
      }
    }
  }
}
