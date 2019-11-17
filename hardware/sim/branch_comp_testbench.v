`timescale 1ns / 1ns

module branch_comp_testbench;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    reg brun;
    wire brlt;
    wire breq;
    
    branch_comp branch_comp_test(
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .brun(brun),
        .brlt(brlt),
        .breq(breq)
);
    initial begin
        rs1_data = 32'd1;
        rs2_data = 32'd2;
        brun = 0;
        #(3)
        $display("rs1:%d, rs2:%d",rs1_data,rs2_data);
        if (breq != 0)
			$display("Failed breq",breq);
		else 
			$display("Passed breq",breq);
		if (brlt != 1)
			$display("Failed brlt",brlt);
		else 
			$display("Passed brlt",brlt);
			
		#(3)
		rs1_data = 32'd3;
        rs2_data = 32'd3;
        brun = 0;
        #(3)
        $display("rs1:%d, rs2:%d",rs1_data,rs2_data);
        if (breq != 1)
			$display("Failed breq",breq);
		else 
			$display("Passed breq",breq);
		if (brlt != 0)
			$display("Failed brlt",brlt);
		else 
			$display("Passed brlt",brlt);
			
		#(3)
		rs1_data = -3;
        rs2_data = 3;
        brun = 1;
        #(3)
        $display("rs1:%d, rs2:%d",rs1_data,rs2_data);
        if (breq != 0)
			$display("Failed breq",breq);
		else 
			$display("Passed breq",breq);
		if (brlt != 1)
			$display("Failed brlt",brlt);
		else 
			$display("Passed brlt",brlt);
       
        $finish();
    end
endmodule