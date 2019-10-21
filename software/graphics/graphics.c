#include "memory_map.h"
#include "i2c.h"
#include "uart.h"
#include "string.h"
#include "ascii.h"
#include "routines.h"

typedef void (*entry_t)(void);

#define BUFFER_LEN 128

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

void i2c_setup() {
    int8_t buffer[BUFFER_LEN];
    uint8_t read_value;

    // Write to the Test Pattern Register (TSTP) 0x48 with data: 0x00
    // This will reset the datapath and registers    
    i2c_write(0x76, 0x48, 0x00);
    uwrite_int8s("\tWrote TSTP to reset chip\r\n");

    // Write to the Test Pattern Register (TSTP) 0x48 with data: 0x18
    // This will bring the chip out of reset
    i2c_write(0x76, 0x48, 0x18);
    read_value = i2c_read(0x76, 0x48);
    uwrite_int8s("\tWrote 0x18 to TSTP, got: ");
    uwrite_int8s(uint8_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");

    // Write to the Power Management Register (PM) 0x49 with data: 0xC0
    // This will turn on the DACs, bring the part out of power down, and will enable VGA bypass mode
    i2c_write(0x76, 0x49, 0xC0);
    read_value = i2c_read(0x76, 0x49);
    uwrite_int8s("\tWrote 0xC0 to PM, got: ");
    uwrite_int8s(uint8_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");

    // Write to the Input Data Format Register (IDF) 0x1F with data: 0x83
    i2c_write(0x76, 0x1F, 0x83);
    read_value = i2c_read(0x76, 0x1F);
    uwrite_int8s("\tWrote 0x83 to IDF, got: ");
    uwrite_int8s(uint8_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");

    // Write to the DAC Control Regsiter (DAC) 0x21 with data: 0x09
    // This will enable the HSYNC and VSYNC outputs and will enable DAC VGA bypass mode
    i2c_write(0x76, 0x21, 0x09);
    read_value = i2c_read(0x76, 0x21);
    uwrite_int8s("\tWrote 0x09 to DAC, got: ");
    uwrite_int8s(uint8_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");

    //// These are specific to a pixel clock <= 65 Mhz
    // Write to the DVI PLL Charge Pump Control Register (TPCP) 0x33 with data: 0x08
    i2c_write(0x76, 0x33, 0x08);
    read_value = i2c_read(0x76, 0x33);
    uwrite_int8s("\tWrote 0x08 to TPCP, got: ");
    uwrite_int8s(uint8_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");
    
    // Write to the DVI PLL Divider Register (TPD) 0x34 with data: 0x16
    i2c_write(0x76, 0x34, 0x16); 
    read_value = i2c_read(0x76, 0x34);
    uwrite_int8s("\tWrote 0x16 to TPD, got: ");
    uwrite_int8s(uint8_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");
    
    // Write to the DVI PLL Filter Register (TPF) 0x36 with data: 0x60
    i2c_write(0x76, 0x36, 0x60);
    read_value = i2c_read(0x76, 0x36);
    uwrite_int8s("\tWrote 0x60 to TPF, got: ");
    uwrite_int8s(uint8_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");

    uwrite_int8s("\tReading Version ID, got: ");
    read_value = i2c_read(0x76, 0x4A);
    uwrite_int8s(uint8_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s(" expected 0x95\r\n");
    
    uwrite_int8s("\tReading Device ID, got: ");
    read_value = i2c_read(0x76, 0x4B);
    uwrite_int8s(uint8_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s(" expected 0x17\r\n");
}

void i2c_set_colorbars() {
    // Write to the Test Pattern Register (TSTP) 0x48 with data: 0x19
    // This will enable test pattern generation
    i2c_write(0x76, 0x48, 0x19);
    uint32_t read_value = i2c_read(0x76, 0x48);
    int8_t buffer[BUFFER_LEN];
    uwrite_int8s(uint32_to_ascii_hex(read_value, buffer, BUFFER_LEN));
    uwrite_int8s("\r\n");
}

int main(void) {
    uwrite_int8s("\r\n");

    for ( ; ; ) {
        uwrite_int8s("graphics> ");

        int8_t buffer[BUFFER_LEN];
        int8_t* input = read_token(buffer, BUFFER_LEN, " \x0d");

        if (strcmp(input, "setup") == 0) {
            // Launch the series of I2C commands to setup the Chrontel DVI chip
            // Should also verify that the I2C writes went through by following
            // them up with a read.
            uwrite_int8s("\tEntering I2C Setup Routine:\r\n");
            i2c_setup();
            uwrite_int8s("\tDone with I2C Setup\r\n");
        }
        else if (strcmp(input, "test_pattern") == 0) {
            uwrite_int8s("\tEnabling test pattern generation.\r\n");
            i2c_set_colorbars();
            uwrite_int8s("\tDone!\r\n");
        }
        else if (strcmp(input, "fill") == 0) {
            uint8_t color = ascii_hex_to_uint8(read_token(buffer, BUFFER_LEN, " \x0d"));
            fill(color);
        }
        else if (strcmp(input, "swline") == 0) {
            uint32_t color = ascii_hex_to_uint32(read_token(buffer, BUFFER_LEN, " \x0d"));
            uint16_t x0 = ascii_dec_to_uint16(read_token(buffer, BUFFER_LEN, " \x0d"));
            uint16_t y0 = ascii_dec_to_uint16(read_token(buffer, BUFFER_LEN, " \x0d"));
            uint16_t x1 = ascii_dec_to_uint16(read_token(buffer, BUFFER_LEN, " \x0d"));
            uint16_t y1 = ascii_dec_to_uint16(read_token(buffer, BUFFER_LEN, " \x0d"));
            swline(color, x0, y0, x1, y1);
        }
        else if (strcmp(input, "pixel") == 0) {
            uint8_t color = ascii_hex_to_uint8(read_token(buffer, BUFFER_LEN, " \x0d"));
            uint32_t x = ascii_dec_to_uint32(read_token(buffer, BUFFER_LEN, " \x0d"));
            uint32_t y = ascii_dec_to_uint32(read_token(buffer, BUFFER_LEN, " \x0d"));
            store_pixel(color, x, y);
        }
        else if (strcmp(input, "deskew") == 0) {
            uint8_t deskew_amount = ascii_hex_to_uint8(read_token(buffer, BUFFER_LEN, " \x0d"));
            // Write to the Input Clock Register (IC) 0x1D with data: 0x4{deskew_amount}
            // Look at datasheet for how this could be used
            uint8_t IC_write_data = ((0x40) | (deskew_amount & 0xF));
            i2c_write(0x76, 0x1D, IC_write_data);
        }
        else if (strcmp(input, "exit") == 0) {
            uint32_t bios = ascii_hex_to_uint32("40000000");
            entry_t start = (entry_t) (bios);
            start();
        }    
    }
    return 0;
}


