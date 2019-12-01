#include "ascii.h"
#include "uart.h"
#include "string.h"
#include "types.h"
#include "memory_map.h"
#include "scale.h"

#define BUFFER_LEN 128

void send_to_pwm(uint32_t sample) {
  PWM_DUTY_CYCLE = sample & 0xfff;
  PWM_REQ = 1;
  while (!PWM_ACK) { asm volatile ("nop"); }
  PWM_REQ = 0;
  while (PWM_ACK) { asm volatile ("nop"); }
}

int main(void) {
  int8_t buffer[BUFFER_LEN];
  uint32_t switch_period = 0;
  uint32_t period_counter = 0;
  uint32_t time_counter = 0;
  uint32_t note_length = (1 << 24);
  uint8_t volume = 0;
  uint8_t wave = 0;
  uint8_t playing_note = 0;

  for (;;) {
    // Read the volume switches to determine how to scale the output
    // waveform.
    volume = SWITCHES & 0x3;

    // Adjust the note length based on button presses
    if (!GPIO_FIFO_EMPTY) {
        uint32_t button_state = GPIO_FIFO_DATA;
        if (button_state & 0x1) {
          note_length = note_length << 1;
          uwrite_int8s("note_length = ");
          uwrite_int8s(uint32_to_ascii_hex(note_length, buffer, BUFFER_LEN));
          uwrite_int8s("\r\n");
        }
        if (button_state & 0x2) {
          note_length = note_length >> 1;
          uwrite_int8s("note_length = ");
          uwrite_int8s(uint32_to_ascii_hex(note_length, buffer, BUFFER_LEN));
          uwrite_int8s("\r\n");
        }
        if (button_state & 0x4) {
          note_length = (1 << 24);
          uwrite_int8s("note_length = ");
          uwrite_int8s(uint32_to_ascii_hex(note_length, buffer, BUFFER_LEN));
          uwrite_int8s("\r\n");
        }
    }

    // Begin playing a new tone if a new key is pressed
    if (URECV_CTRL) {
        uint8_t byte = URECV_DATA;
        uint32_t tone = switch_periods[byte];
        if (switch_period) {
          switch_period = tone;
          period_counter = 0;
          time_counter = 0;
          playing_note = 1;
          send_to_pwm(0);
          COUNTER_RST = 0;
        }
        else {
          switch_period = 0;
        }
    }

    if ((CYCLE_COUNTER >= switch_period) && playing_note) {
      if (wave) {
        send_to_pwm(256 << volume);
      } else {
        send_to_pwm(0);
      }
      wave = wave == 0 ? 1 : 0;
      time_counter += CYCLE_COUNTER;
      COUNTER_RST = 0;
    }

    if (time_counter >= note_length) {
      playing_note = 0;
    }
  }
  return 0;
}
