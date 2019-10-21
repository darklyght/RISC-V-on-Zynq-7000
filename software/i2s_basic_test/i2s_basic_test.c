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

typedef void (*entry_t)(void);

int main(void) {
  TONE_GEN_OUTPUT_ENABLE = 1;
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
    if (!GPIO_FIFO_EMPTY) {
      uint32_t button_state = GPIO_FIFO_DATA;
      if (button_state & 0x1) { // BUTTONS[0]
        // FYDP: uwrite_int8s("BUTTONS[0] pressed\r\n");
        counter = 0;
        tone_period += 2;
      } else if (button_state & 0x2) { // BUTTONS[1]
        // FYDP: uwrite_int8s("BUTTONS[1] pressed\r\n");
        counter = 0;
        tone_period -= 2;
      } else if (button_state & 0x4) { // BUTTONS[2]
        // FYDP: uwrite_int8s("BUTTONS[2] pressed\r\n");
        counter = 0;
        tone_period = 54 + 54;
      }
    }

    if (counter < (tone_period >> 1)) {
      while(I2S_FULL);
      next_sample = sample_table[volume << 1];
      // FYDP: LED_CONTROL = next_sample;
      I2S_DATA = next_sample;
      TONE_GEN_TONE_INPUT = tone_period << 4;
      // FYDP: uwrite_int8s("Sent high.\n");
    }
    else if (counter >= (tone_period >> 1)) {
      while(I2S_FULL);
      next_sample = sample_table[(volume << 1) + 1];
      I2S_DATA = next_sample;
      // FYDP: uwrite_int8s("Sent low.\n");
    }
    counter++;
    if (counter >= tone_period) {
      counter = 0;
    }
    LED_CONTROL = tone_period;
  }

  return 0;
}
