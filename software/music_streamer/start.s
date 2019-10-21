.section    .start
.global     _start

_start:
    li      sp, 0x1000a000
    jal     main
