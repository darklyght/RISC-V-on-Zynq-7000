#include "graphics.h"
#include "uart.h"
#include "ascii.h"
#include "types.h"


void fill(uint32_t color)
{
  while (!(FILLER_CTRL)) ;
  FILLER_COLOR = color;
}

void hwline(uint32_t color, uint16_t x0, uint16_t y0, uint16_t x1, uint16_t y1)
{
  while (!(LE_CTRL & FILLER_CTRL)) ;
  LE_COLOR = color;
  LE_X0 = x0;
  LE_Y0 = y0;
  LE_X1 = x1;
  LE_Y1TRIG = y1;
}



void swap(int* a, int* b) 
{
  int tmp = *a;
  *a = *b;
  *b = tmp;
}

uint16_t abs(int a) 
{
   if (a < 0)
       return -a;
   return a;
}

void store_pixel(uint32_t color, int x, int y)
{
   uwrite_int8s("Storing pixel:");
   int8_t buffer[64];
   uint32_t y_addr = (y & 0x3FF) << 12;
   uint32_t x_addr = (x & 0x3FF) << 2;
   uint32_t address = 0x40400000 | y_addr | x_addr;
   volatile uint32_t* p = (volatile uint32_t*)(address);
   uwrite_int8s(uint32_to_ascii_hex(address, buffer, 64));
   uwrite_int8s("\r\n");
   *p = color;
}

/* Based on wikipedia implementation */
void swline(uint32_t color, int x0, int y0, int x1, int y1)
{
  char steep = (abs(y1-y0) > abs(x1-x0)) ? 1 : 0; 
  if(steep) {
    swap(&x0, &y0);
    swap(&x1, &y1);
  }
  if( x0 > x1 ) {
    swap(&x0, &x1);
    swap(&y0, &y1);
  }
  int deltax = x1 - x0;
  int deltay = abs(y1-y0);
  int error = deltax / 2;
  int ystep;
  int y = y0;
  int x;
  ystep = (y0 < y1) ? 1 : -1;
  for( x = x0; x <= x1; x++ ) {
    if(steep)
      store_pixel(color, y, x);
    else
      store_pixel(color, x, y);
    error = error - deltay;
    if( error < 0 ) {
      y += ystep;
      error += deltax;
    }
  }
}

