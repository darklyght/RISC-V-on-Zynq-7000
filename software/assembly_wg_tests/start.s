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
li x2, 0
sw x2, 260(x1)
li x2, 0
sw x2, 512(x1)
li x2, 31
sw x2, 516(x1)
li x2, 31
sw x2, 520(x1)
li x2, 31
sw x2, 524(x1)
li x2, 1
sw x2, 68(x1)
li x3, 4096
add x1, x1, x3
li x2, 450560
sw x2, 0(x1)
sw x0, 4(x1)
Done: j Done

