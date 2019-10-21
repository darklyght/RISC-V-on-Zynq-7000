// FYDP: For Your Debugging Pleasure

#include "ascii.h"
#include "uart.h"
#include "string.h"
#include "types.h"
#include "memory_map.h"

// Low and high sample values of the square wave.
// (Our I2S controller sample width is 24 bits of signed PCM.)
//
// Chosen so that multiplying by 3 doesn't oveflow the 24-bit value.
//
// But we actually can't multiply by anything; we don't support MUL
// instructions. So we need a table.
#define HIGH_AMPLITUDE 0x2AAAA
#define LOW_AMPLITUDE -0x2AAAA

#define BUFFER_LEN 128

#define RECV_CTRL (*((volatile unsigned int*)0x80000000) & 0x02)
#define RECV_DATA (*((volatile unsigned int*)0x80000004) & 0xFF)

typedef void (*entry_t)(void);

int main(void) {
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

  int8_t buffer[BUFFER_LEN];
  uint32_t tone_period = 54 + 54;
  uint32_t counter = 0;

  uint32_t sample_table[] = { 0x000000, 0x000000,   // Volume 0
                              0x2AAAAA, -0x2AAAAA,  // Volume 1
                              0x555554, -0x555554,  // Volume 2
                              0x7FFFFE, -0x7FFFFE}; // Volume 3

  // Since our I2S controller doesn't have volume control, it's up to us to
  // reduce its volume in software.
  uint32_t volume = 0;
  uint32_t next_sample = 0;

  for (;;) {
    // Read the volume switches to determine how to scale the output
    // waveform.
    volume = DIP_SWITCHES & 0xF;

    // Adjust the tone_period if a push is detected.
    if (RECV_CTRL) {
        char byte = RECV_DATA;
        short ff = ffs[byte];
        //short ff = 108;
        if (ff) tone_period = ff;
        else tone_period = 0;
    }

    if (counter < (tone_period >> 1)) {
      while(I2S_FULL);
      next_sample = 0x7FFFFE;
      //LED_CONTROL = next_sample;
      I2S_DATA = next_sample;
      //uwrite_int8s("Sent high.\n");
    }
    else if (counter >= (tone_period >> 1)) {
      while(I2S_FULL);
      next_sample = -0x7FFFFE;
      I2S_DATA = next_sample;
      //uwrite_int8s("Sent low.\n");
    }
    counter++;
    if (counter >= tone_period) {
      counter = 0;
    }
    LED_CONTROL = tone_period;
  }

  return 0;
}
