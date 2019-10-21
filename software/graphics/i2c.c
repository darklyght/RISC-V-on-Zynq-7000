#include "memory_map.h"

uint8_t i2c_read(uint8_t slave_addr, uint8_t reg_addr) {
    // Wait for I2C controller to become ready
    while(!I2C_CONTROLLER_READY);

    // Set the I2C controller's slave addr
    // I2C_SLAVE_ADDR = 16-bits = {8'd0, slave_addr[6:0], r/w}
    // where r/w = 1 (read), 0 (write)
    I2C_SLAVE_ADDR = (slave_addr << 1) | 1;

    // Set the I2C controller's reg addr
    // I2C_REG_ADDR = 16 bits = {num_bytes[7:0], reg_addr[7:0]}
    I2C_REG_ADDR = (1 << 8) | (reg_addr & 0xFF);

    // Fire off the I2C read request
    I2C_CONTROLLER_FIRE = 1;

    // Insert a few nops just in case before polling rdata_valid
    __asm__("nop"::);
    __asm__("nop"::);

    // Poll the I2C controller's rdata valid output until it goes high
    while(!I2C_CONTROLLER_READ_DATA_VALID);

    uint32_t read_data;
    read_data = I2C_READ_DATA;
    return read_data;
}

void i2c_write(uint8_t slave_addr, uint8_t reg_addr, uint8_t write_data) {
    // Wait for I2C controller to become ready
    while(!I2C_CONTROLLER_READY);
    
    // Set the I2C controller's slave addr
    I2C_SLAVE_ADDR = (slave_addr << 1) | 0;
    
    // Set the I2C controller's reg addr
    I2C_REG_ADDR = (1 << 8) | (reg_addr & 0xFF);
    
    // Set he I2C controller's write data
    I2C_WRITE_DATA = write_data & 0xFF;
    
    // Fire off the I2C read request
    I2C_CONTROLLER_FIRE = 1;

    // Insert a few nops just in case before polling controller_ready
    __asm__("nop"::);
    __asm__("nop"::);
    
    // Wait until the write has gone through and then return
    while(!I2C_CONTROLLER_READY);
    return;
}

