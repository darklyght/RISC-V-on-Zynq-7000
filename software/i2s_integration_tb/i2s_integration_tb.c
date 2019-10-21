#include "memory_map.h"

// This program sends the PCM samples -50, ..., 50 to your I2S sample FIFO
int main(void) {
    int i;
    for (i = -50; i <= 50; i++) {
        while(I2S_FULL);
        I2S_DATA = i;
    }

    // Once we are done, the program should just stop sending samples
    jump_here: i = 0;
    goto jump_here;
    return 0;
}
