.section    .start
.global     _start

_start:

# Follow a convention
# x1 = result register 1
# x2 = result register 2
# x10 = argument 1 register
# x11 = argument 2 register
# x20 = flag register

lui x1, 0x80000
li x2, 2048
sw x2, 52(x1)
li x2, 1
sw x2, 56(x1)

Done: j Done

