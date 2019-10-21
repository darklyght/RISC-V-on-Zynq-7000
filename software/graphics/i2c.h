#ifndef I2C_H_
#define I2C_H_

#include "types.h"

uint32_t i2c_read(uint32_t slave_addr, uint32_t reg_addr);
void i2c_write(uint32_t slave_addr, uint32_t reg_addr, uint32_t write_data);

#endif
