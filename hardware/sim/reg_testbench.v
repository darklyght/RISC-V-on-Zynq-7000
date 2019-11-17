`timescale 1ns / 1ns

module reg_testbench;
	reg clk;
	initial clk = 0;
	always #(4) clk = ~clk;
    reg we;
    reg [4:0] ra1, ra2, wa;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

	reg_file reg_test(
	.clk(clk),
	.we(we),
	.ra1(ra1),
	.ra2(ra2),
	.wa(wa),
	.wd(wd),
	.rd1(rd1),
	.rd2(rd2)
);

	initial begin
		we = 1'b1;
		ra1 = 5'b0;
		ra2 = 5'b0;
		wd = 32'b001;
		wa = 5'b0;
		#(3)
		$display(“Write back 001 to x0, rd1:%b, rd2:%b",rd1,rd2);
		
		we = 1'b1;
		ra1 = 5'b0;
		ra2 = 5'b0;
		wd = 32'b001;
		wa = 5'd1;
		#(3)
		$display(“Write back 001 to x1, rd1:%b, rd2:%b",rd1,rd2);
		
		we = 1'b1;
		ra1 = 5'd1;
		ra2 = 5'd0;
		wd = 32'b010;
		wa = 5'd2;
		#(3)
		$display(“Write back 010 to x2, rd1:%b, rd2:%b",rd1,rd2);

		we = 1'b0;
		ra1 = 5'd1;
		ra2 = 5'd2;
		wd = 32'b010;
		wa = 5'd2;
		#(3)
		$display(“Read, rd1:%b, rd2:%b",rd1,rd2);

		$finish();
	end
endmodule





