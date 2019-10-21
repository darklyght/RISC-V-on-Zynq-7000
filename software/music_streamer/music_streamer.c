#include "ascii.h"
#include "uart.h"
#include "string.h"
#include "music.h"
#include "memory_map.h"

#define BUFFER_LEN 128

#define CPU_CLOCK_FREQ 50000000
#define NOTE_HOLD_TIME CPU_CLOCK_FREQ/25
#define INITIAL_SEQUENCER_TONE (CPU_CLOCK_FREQ/440)/2

typedef void (*entry_t)(void);

enum state_t {
    REGULAR_PLAY, PAUSED, REVERSE_PLAY, PLAY_SEQ, EDIT_SEQ
};
typedef enum state_t state;

static state current_state = REGULAR_PLAY;
static uint32_t tone_index = 0;
static uint32_t sequencer_index = 0;
static uint32_t music_tempo = NOTE_HOLD_TIME;
static uint32_t sequencer_tempo = NOTE_HOLD_TIME;
static uint32_t sequencer_mem[8];
static uint32_t tone_under_edit;

void print_music_tempo() {
    int8_t buffer[BUFFER_LEN];
    uwrite_int8s("Music Tempo: ");
    uwrite_int8s(uint32_to_ascii_hex(music_tempo, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");
}

void print_sequencer_tempo() {
    int8_t buffer[BUFFER_LEN];
    uwrite_int8s("Sequencer Tempo: ");
    uwrite_int8s(uint32_to_ascii_hex(sequencer_tempo, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");
}

void print_tone_under_edit() {
    int8_t buffer[BUFFER_LEN];
    uwrite_int8s("Tone Under Edit: ");
    uwrite_int8s(uint32_to_ascii_hex(tone_under_edit, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");
}

void take_button_action (uint32_t button_state) {
    int8_t buffer[BUFFER_LEN];
    if (button_state & 0x1) { // BTN0 -- play/pause
        if (current_state == REGULAR_PLAY || current_state == REVERSE_PLAY || current_state == PLAY_SEQ) {
            current_state = PAUSED;
            uwrite_int8s("Moving to PAUSED state\r\n");
        }
        else if (current_state == PAUSED) {
            current_state = REGULAR_PLAY;
            uwrite_int8s("Moving to REGULAR_PLAY state\r\n");
        }
    }
    if (button_state & 0x2) { // BTN1 -- reverse play
        if (current_state == REGULAR_PLAY) {
            current_state = REVERSE_PLAY;
            uwrite_int8s("Moving to REVERSE_PLAY state\r\n");
        }
        else if (current_state == REVERSE_PLAY) {
            current_state = REGULAR_PLAY;
            uwrite_int8s("Moving to REGULAR_PLAY state\r\n");
        }
        else if (current_state == PLAY_SEQ) {
            current_state = EDIT_SEQ;
            tone_under_edit = sequencer_mem[sequencer_index];
            uwrite_int8s("Moving to EDIT_SEQ state\r\n");
        }
        else if (current_state == EDIT_SEQ) {
            current_state = PLAY_SEQ;
            uwrite_int8s("Moving to PLAY_SEQ state\r\n");
        }
    }
    if (button_state & 0x4) { // BTN2 -- tempo reset
        if (current_state == EDIT_SEQ) {
            sequencer_mem[sequencer_index] = tone_under_edit;
            uwrite_int8s("Wrote note: ");
            uwrite_int8s(uint32_to_ascii_hex(tone_under_edit, buffer, BUFFER_LEN));
            uwrite_int8s(" to sequencer index: ");
            uwrite_int8s(uint32_to_ascii_hex(sequencer_index, buffer, BUFFER_LEN));
            uwrite_int8s("\r\n");
        }
        else if (current_state == PLAY_SEQ) {
            sequencer_tempo = NOTE_HOLD_TIME;
            uwrite_int8s("Sequencer Tempo Reset\r\n");
            print_sequencer_tempo();
        }
        else {
            music_tempo = NOTE_HOLD_TIME;
            uwrite_int8s("Music Tempo Reset\r\n");
            print_music_tempo();
        }
    }
    /********************************************************** 
    Comment out the following two if() statements if you want to add tempo adjustment. 
    Note that you probably have to use switches to get this part working due to a lack of buttons.
    /**********************************************************/

    // if (button_state & 0x2) { // 
    //     if (current_state == REGULAR_PLAY || current_state == REVERSE_PLAY || current_state == PAUSED) {
    //         music_tempo += 30000;
    //         print_music_tempo();
    //     } else if (current_state == PLAY_SEQ) {
    //         sequencer_tempo += 30000;
    //         print_sequencer_tempo();
    //     } else { // EDIT_SEQ
    //         tone_under_edit += 1000;
    //         print_tone_under_edit();
    //     }
    // }
    // if (button_state & 0x4) { // 
    //     if (current_state == REGULAR_PLAY || current_state == REVERSE_PLAY || current_state == PAUSED) {
    //         music_tempo -= 30000;
    //         print_music_tempo();
    //     } else if (current_state == PLAY_SEQ) {
    //         sequencer_tempo -= 30000;
    //         print_sequencer_tempo();
    //     } else { // EDIT_SEQ
    //         tone_under_edit -= 1000;
    //         print_tone_under_edit();
    //     }
    // }

    /********************************************************** 
    Comment out the following two if() statements if you want to add sequencer functionality. 
    Note that you will have to figure out which buttons/switches control and change the code,
    as this was written for a different FPGA.
    /**********************************************************/
    // if (button_state & 0x8) { // West button push
    //     if (current_state == EDIT_SEQ) {
    //         sequencer_index = sequencer_index == 0 ? 7 : sequencer_index - 1;
    //         tone_under_edit = sequencer_mem[sequencer_index];
    //         uwrite_int8s("Editing note: ");
    //         uwrite_int8s(uint32_to_ascii_hex(sequencer_index, buffer, BUFFER_LEN));
    //         uwrite_int8s("\r\n");
    //     }
    // }
    // if (button_state & 0x20) { // East button push
    //     if (current_state == EDIT_SEQ) {
    //         sequencer_index = sequencer_index == 7 ? 0 : sequencer_index + 1;
    //         tone_under_edit = sequencer_mem[sequencer_index];
    //         uwrite_int8s("Editing note: ");
    //         uwrite_int8s(uint32_to_ascii_hex(sequencer_index, buffer, BUFFER_LEN));
    //         uwrite_int8s("\r\n");
    //     }
    // }
    // if (button_state & 0x40) { // North button push
    //     if (current_state == REGULAR_PLAY || current_state == PAUSED) {
    //         current_state = PLAY_SEQ;
    //         uwrite_int8s("Moving to PLAY_SEQ state\r\n");
    //     }
    //     else if (current_state == PLAY_SEQ) {
    //         current_state = REGULAR_PLAY;
    //         uwrite_int8s("Moving to REGULAR_PLAY state\r\n");
    //     }
    // }
}

int main(void) {
    int8_t buffer[BUFFER_LEN];
    uwrite_int8s("\r\n");
    TONE_GEN_OUTPUT_ENABLE = 1;
    COUNTER_RST = 0;

    for (int i = 0; i < 8; i++) {
        sequencer_mem[i] = INITIAL_SEQUENCER_TONE;
    }

    for( ; ; ) {
        // Play the current note based on state
        if (current_state == REGULAR_PLAY || current_state == REVERSE_PLAY) {
            TONE_GEN_OUTPUT_ENABLE = 1;
            TONE_GEN_TONE_INPUT = music[tone_index];
        }
        else if (current_state == PAUSED) {
            TONE_GEN_OUTPUT_ENABLE = 0;
        }
        else if (current_state == PLAY_SEQ) {
            TONE_GEN_OUTPUT_ENABLE = 1;
            TONE_GEN_TONE_INPUT = sequencer_mem[sequencer_index];
        }
        else if (current_state == EDIT_SEQ) {
            TONE_GEN_OUTPUT_ENABLE = 1;
            TONE_GEN_TONE_INPUT = tone_under_edit;
        }

        // Advance tone_index based on state
        if (current_state == REGULAR_PLAY) {
            if (CYCLE_COUNTER > music_tempo) {
                tone_index = tone_index == MUSIC_LENGTH - 1 ? 0 : tone_index + 1;
                COUNTER_RST = 0;
            }
        }
        else if (current_state == PAUSED) {
            COUNTER_RST = 0;
        }
        else if (current_state == REVERSE_PLAY) {
            if (CYCLE_COUNTER > music_tempo) {
                tone_index = tone_index == 0 ? MUSIC_LENGTH - 1 : tone_index - 1;
                COUNTER_RST = 0;
            }
        }
        else if (current_state == PLAY_SEQ) {
            if (CYCLE_COUNTER > sequencer_tempo) {
                sequencer_index = sequencer_index == 7 ? 0 : sequencer_index + 1;
                COUNTER_RST = 0;
            }
        }

        // Watch for any user I/O and respond accordingly
        if (!GPIO_FIFO_EMPTY) {
            uint32_t button_state = GPIO_FIFO_DATA;
            take_button_action(button_state);
        }

        // Show the current note state on the LEDs
        if (current_state == PLAY_SEQ || current_state == EDIT_SEQ) {
            switch (sequencer_index) {
                case 0: LED_CONTROL = 0x1; break;
                case 1: LED_CONTROL = 0x2; break;
                case 2: LED_CONTROL = 0x4; break;
                case 3: LED_CONTROL = 0x8; break;
                case 4: LED_CONTROL = 0x10; break;
                case 5: LED_CONTROL = 0x20; break;
                case 6: LED_CONTROL = 0x40; break;
                case 7: LED_CONTROL = 0x80; break;
            }
        }
        else {
            LED_CONTROL = (tone_index >> 5) & 0xff;
        }
    }

    return 0;
}

