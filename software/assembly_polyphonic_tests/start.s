.section    .start
.global     _start

_start:

# Follow a convention
# x1 = result register 1
# x2 = result register 2
# x10 = argument 1 register
# x11 = argument 2 register
# x20 = flag register

#32'h80000104, global_shift = 0
lui x1, 0x80000
li x2, 0
sw x2, 260(x1)

#32'h80000200, sine_shift = 0
li x2, 0
sw x2, 512(x1)

#32'h80000204, square_shift = 11111
li x2, 31
sw x2, 516(x1)

#32'h80000208, triangle_shift = 11111
li x2, 31
sw x2, 520(x1)

#32'h8000020c, triangle_shift = 11111
li x2, 31
sw x2, 524(x1)

#32'h80000044, dac_source = 1
li x2, 1
sw x2, 68(x1)

#32'h80001xxx, voice_1
li x3, 4096
add x1, x1, x3
#32'h80001000, fcw_1 = 450560
li x2, 450560
sw x2, 0(x1)
#32'h80001004, note_start_1
sw x0, 4(x1)

#32'h80002xxx, voice_2
li x3, 4096
add x1, x1, x3
#32'h80002000, fcw_2 = 420320
li x2, 420320
sw x2, 0(x1)
#32'h80002004, note_start_2
sw x0, 4(x1)

#32'h80004xxx, voice_3
li x3, 8192
add x1, x1, x3
#32'h80004000, fcw_3 = 400200
li x2, 400200
sw x2, 0(x1)
#32'h80004004, note_start_3
sw x0, 4(x1)

#32'h80008xxx, voice_4
li x3, 16384
add x1, x1, x3
#32'h80008000, fcw_4 = 380640
li x2, 380640
sw x2, 0(x1)
#32'h80008004, note_start_4
sw x0, 4(x1)

#loop for delay
li x5, 0
li x6, 100
li x7, 0
loop:
beq x7, x6, exit
addi x7, x5, 1
jar x0, loop

exit:
#32'h80001xxx, voice_1
lui x1, 0x80001
#32'h80001008, note_release_1
sw x0, 8(x1)

#32'h80002xxx, voice_2
li x3, 4096
add x1, x1, x3
#32'h80002008, note_release_2
sw x0, 8(x1)

#32'h80004xxx, voice_3
li x3, 8192
add x1, x1, x3
#32'h80002008, note_release_3
sw x0, 8(x1)

#32'h80008xxx, voice_4
li x3, 16384
add x1, x1, x3
#32'h80002008, note_release_4
sw x0, 8(x1)

#check 32'h8000100c ,voice_1_finished
lui x1, 0x80001
lw x8, 12(x1)
li x20, 1

#check 32'h8000200c ,voice_2_finished
lui x1, 0x80002
lw x9, 12(x1)
li x20, 2

#check 32'h8000300c ，voice_3_finished
lui x1, 0x80003
lw x10, 12(x1)
li x20, 3

#check 32'h8000400c ，voice_4_finished
lui x1, 0x80004
lw x11, 12(x1)
li x20, 4

#32'h80001010, set reset = 1
lui x1, 0x80001
li x2, 1
sw x2, 16(x1)

Done: j Done

