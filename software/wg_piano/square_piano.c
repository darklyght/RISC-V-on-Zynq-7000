#include "ascii.h"
#include "uart.h"
#include "string.h"
#include "types.h"
#include "memory_map.h"
#include "scale.h"
#include "scale2.h"
#include "scale3.h"

#define GLOBAL_SHIFT (*((volatile uint32_t*) 0x80000104))
#define SINE_SHIFT (*((volatile uint32_t*) 0x80000200))
#define SQUARE_SHIFT (*((volatile uint32_t*) 0x80000204))
#define TRIANGLE_SHIFT (*((volatile uint32_t*) 0x80000208))
#define SAWTOOTH_SHIFT (*((volatile uint32_t*) 0x8000020C))
#define DAC_SOURCE (*((volatile uint32_t*) 0x80000044))
#define GLOBAL_RESET (*((volatile uint32_t*) 0x80000100))
#define VOICE1_FCW (*((volatile uint32_t*) 0x80001000))
#define VOICE1_START (*((volatile uint32_t*) 0x80001004))
#define VOICE1_RELEASE (*((volatile uint32_t*) 0x80001008))
#define VOICE1_FINISHED (*((volatile uint32_t*) 0x8000100C))
#define VOICE1_RESET (*((volatile uint32_t*) 0x80001010))
#define VOICE2_FCW (*((volatile uint32_t*) 0x80002000))
#define VOICE2_START (*((volatile uint32_t*) 0x80002004))
#define VOICE2_RELEASE (*((volatile uint32_t*) 0x80002008))
#define VOICE2_FINISHED (*((volatile uint32_t*) 0x8000200C))
#define VOICE2_RESET (*((volatile uint32_t*) 0x80002010))
#define VOICE3_FCW (*((volatile uint32_t*) 0x80004000))
#define VOICE3_START (*((volatile uint32_t*) 0x80004004))
#define VOICE3_RELEASE (*((volatile uint32_t*) 0x80004008))
#define VOICE3_FINISHED (*((volatile uint32_t*) 0x8000400C))
#define VOICE3_RESET (*((volatile uint32_t*) 0x80004010))

#define BUFFER_LEN 128

int8_t buffer[BUFFER_LEN];

int main(void) {
  int8_t buffer[BUFFER_LEN];
  uint32_t switch_period = 0;
  uint32_t period_counter = 0;
  uint32_t time_counter = 0;
  uint32_t note_length = (1 << 24);
  uint8_t volume = 0;
  uint8_t wave = 0;
  uint8_t playing_note = 0;

  GLOBAL_SHIFT = 0x0;
  SINE_SHIFT = 0x1F;
  SQUARE_SHIFT = 0x0;
  TRIANGLE_SHIFT = 0x1F;
  SAWTOOTH_SHIFT = 0x1F;
  DAC_SOURCE = 0x1;
  GLOBAL_RESET = 0;
  for (;;) {
    
    // Read the volume switches to determine how to scale the output
    // waveform.
    volume = SWITCHES & 0x3;
    
    if (volume == 0) {
        SINE_SHIFT = 0x0;
        SQUARE_SHIFT = 0x1F;
        TRIANGLE_SHIFT = 0x1F;
        SAWTOOTH_SHIFT = 0x1F;
    }
    if (volume == 1) {
        SINE_SHIFT = 0x1F;
        SQUARE_SHIFT = 0x0;
        TRIANGLE_SHIFT = 0x1F;
        SAWTOOTH_SHIFT = 0x1F;
    }
    if (volume == 2) {
        SINE_SHIFT = 0x1F;
        SQUARE_SHIFT = 0x1F;
        TRIANGLE_SHIFT = 0x0;
        SAWTOOTH_SHIFT = 0x1F;
    }
    if (volume == 3) {
        SINE_SHIFT = 0x1F;
        SQUARE_SHIFT = 0x1F;
        TRIANGLE_SHIFT = 0x1F;
        SAWTOOTH_SHIFT = 0x0;
    }
    // Adjust the note length based on button presses
    if (!GPIO_FIFO_EMPTY) {
        uint32_t button_state = GPIO_FIFO_DATA;
        if (button_state & 0x1) {
          note_length = note_length << 1;
        }
        if (button_state & 0x2) {
          note_length = note_length >> 1;
        }
        if (button_state & 0x4) {
          note_length = (1 << 24);
        }
        uwrite_int8s("note_length = ");
        uwrite_int8s(uint32_to_ascii_hex(note_length, buffer, BUFFER_LEN));
        uwrite_int8s("\r\n");
    }

    // Begin playing a new tone if a new key is pressed
    if (URECV_CTRL) {
        uint8_t byte = URECV_DATA;
        uint32_t tone = switch_periods[byte];
        uint32_t tone_2 = switch_periods_2[byte];
        uint32_t tone_3 = switch_periods_3[byte];
        if (tone) {
          GLOBAL_RESET = 0;
          VOICE1_FCW = tone;
          VOICE1_START = 0;
          VOICE2_FCW = tone_2;
          VOICE2_START = 0;
          VOICE3_FCW = tone_3;
          VOICE3_START = 0;
          playing_note = 1;
        }
        else {
          VOICE1_FCW = 0;
          VOICE1_RESET = 0;
          VOICE2_FCW = 0;
          VOICE2_RESET = 0;
          VOICE3_FCW = 0;
          VOICE3_RESET = 0;
          playing_note = 0;
        }
        time_counter = 0;
        COUNTER_RST = 0;
    }

    if (playing_note) {
      time_counter += CYCLE_COUNTER;
      COUNTER_RST = 0;
    }

    if (time_counter >= note_length) {
      playing_note = 0;
      VOICE1_RELEASE = 0;
      VOICE1_RESET = 0;
      VOICE2_RELEASE = 0;
      VOICE2_RESET = 0;
      VOICE3_RELEASE = 0;
      VOICE3_RESET = 0;
      GLOBAL_RESET = 0;
    }
  }
  return 0;
}
