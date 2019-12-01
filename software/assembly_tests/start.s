.section    .start
.global     _start

_start:

# Follow a convention
# x1 = result register 1
# x2 = result register 2
# x10 = argument 1 register
# x11 = argument 2 register
# x20 = flag register

# Test ADD
li x10, 100		# Load argument 1 (rs1)
li x11, 200		# Load argument 2 (rs2)
add x1, x10, x11	# Execute the instruction being tested
li x20, 1		# Set the flag register to stop execution and inspect the result register
			# Now we check that x1 contains 300

# Test BEQ
li x2, 100		# Set an initial value of x2
beq x0, x0, branch1	# This branch should succeed and jump to branch1
li x2, 123		# This shouldn't execute, but if it does x2 becomes an undesirable value
branch1: li x1, 500	# x1 now contains 500
li x20, 2		# Set the flag register
			# Now we check that x1 contains 500 and x2 contains 100
# Test x0
li x1, 100
li x0, 200
add x0, x1, x0
li x20, 3

# Test SH
li x1, 1001
li x2, 1002
li x3, 1024
sh x1, 0(x3)
sh x2, 2(x3)
lw x4, 0(x3)
li x20, 4

# Test BGE, ADDI
li x1, 1
li x2, 2
li x3, 0
bge x1, x2, branch2
li x3, 100
branch2: addi x3, x3, 100
li x20, 5

#test JAL
li x1, 2
li x3, 0
jal x2, end
add x3, x1, x0
end: nop
li x20, 6


Done: j Done

