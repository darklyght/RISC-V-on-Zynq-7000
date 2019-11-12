#include "types.h"
#include "benchmark.h"
#include "ascii.h"
#include "uart.h"

#define N 6
#define DATA (int32_t *) 0x10018000

/* Computes S = AB where A, B, and S are all of 2^N x 2^N matrices. A, B, and S
 * are stored sequentially in row-major order beginning at DATA. Prints the sum
 * of the entries of S to the UART. */

int32_t times(int32_t a, int32_t b) {
    int32_t a_neg = a < 0;
    int32_t b_neg = b < 0;
    int32_t result = 0;
    if (a_neg) a = -a;
    if (b_neg) b = -b;
    while (b) {
        if (b & 1) {
        	result += a;
        }
        a <<= 1;
        b >>= 1;
    }
    if ((a_neg && !b_neg) || (!a_neg && b_neg)) {
        result = -result;
    }
    return result;
}

uint32_t mmult() {
    int32_t sum = 0;
    int32_t dim_size = 1 << N;
    int32_t m_size = 1 << (N << 1);
    int32_t* A = DATA;
    int32_t* B = DATA + m_size;
    int32_t* S = DATA + m_size + m_size;
    int32_t i, j, k;
    for (i = 0; i < dim_size; i++) {
        for (j = 0; j < dim_size; j++) {
            int32_t* s = S + (i << N) + j;
            *s = 0;
            for (k = 0; k < dim_size; k++) {
                int32_t a = *(A + (i << N) + k);
                int32_t b = *(B + (k << N) + j);
                int32_t prod = times(a, b);
                *s = *s + times(a, b);
            }
            sum += *s;
        }
    }
    return (uint32_t) sum;
}

void generate_matrices() {
    int32_t* it = DATA;
    int32_t dim_size = 1 << N;
    int32_t i, j;
    for (i = 0; i < dim_size; i++) {
        for (j = 0; j < dim_size; j++) {
            *it = (i == j) ? 1 : 0;
            it++;
        }
    }
    for (i = 0; i < dim_size; i++) {
        for (j = 0; j < dim_size; j++) {
            *it = j;
            it++;
        }
    }
}


typedef void (*entry_t)(void);

int main(int argc, char**argv) {
    generate_matrices();
    run_and_time(&mmult);
    // go back to the bios - using this function causes a jr to the addr,
    // the compiler "jals" otherwise and then cannot set PC[31:28]
    uint32_t bios = ascii_hex_to_uint32("40000000");
    entry_t start = (entry_t) (bios);
    start();
    return 0;
}
