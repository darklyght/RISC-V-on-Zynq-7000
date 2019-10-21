#include "routines.h"
#include "uart.h"
#include "ascii.h"
#include "types.h"

#define FRAMEBUFFER_BASE 0x90000000

void fill(uint8_t color) {
    int i;
    for (i = 0; i < 7834272; i++) {
        (*((volatile uint8_t*)(FRAMEBUFFER_BASE + i))) = color & 0x1;
    }
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
   (*((volatile uint8_t*)(FRAMEBUFFER_BASE + (y << 10) + x))) = color & 0x1;
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

