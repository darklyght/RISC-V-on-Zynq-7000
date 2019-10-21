.section    .start
.global     _start

_start:
    li      sp, 0x10006000
    jal     main
