#include "ascii.h"
#include "uart.h"
#include "string.h"
#include "memory_map.h"

#define BUFFER_LEN 128

typedef void (*entry_t)(void);

int8_t* read_token(int8_t* b, uint32_t n, int8_t* ds)
{
    for (uint32_t i = 0; i < n; i++) {
        int8_t ch = uread_int8();
        for (uint32_t j = 0; ds[j] != '\0'; j++) {
            if (ch == ds[j]) {
                b[i] = '\0';
                return b;
            }
        }
        b[i] = ch;
    }
    b[n - 1] = '\0';
    return b;
}

int main(void) {

    uwrite_int8s("\r\n");

    for ( ; ; ) {
        uwrite_int8s("tone_gen> ");

        int8_t buffer[BUFFER_LEN];
        int8_t* input = read_token(buffer, BUFFER_LEN, " \x0d");

        if (strcmp(input, "on") == 0) {
            TONE_GEN_OUTPUT_ENABLE = 0x1;
        } else if (strcmp(input, "off") == 0) {
            TONE_GEN_OUTPUT_ENABLE = 0x0;
        } else if (strcmp(input, "tone") == 0){
            uint32_t tone_switch_period = ascii_hex_to_uint32(read_token(buffer, BUFFER_LEN, " \x0d"));	
            TONE_GEN_TONE_INPUT = tone_switch_period;
        } else if (strcmp(input, "exit") == 0) {
            uint32_t bios = ascii_hex_to_uint32("40000000");
            entry_t start = (entry_t) (bios);
            start();
        } else {
            uwrite_int8s("\tUnrecognized token: ");
            uwrite_int8s(input);
            uwrite_int8s("\r\n");
        }
    }

    return 0;
}

