`timescale 1ns / 1ns

module alu_testbench;
	reg [31:0] alu_in_1;
    reg [31:0] alu_in_2;
    reg [2:0] funct3;
	reg [4:0] funct5;
    reg bit30;
    wire [31:0] alu_out;

	alu alu_test(
		.alu_in_1(alu_in_1),
		.alu_in_2(alu_in_2),
		.funct3(funct3),
		.funct5(funct5),
		.bit30(bit30),
		.alu_out(alu_out)
	);
	
	initial begin
		// Test Jalr
		alu_in_1 = 32'd5;
		alu_in_2 = 32'd3;
		funct5 = 5'b11001; //OPC_JALR_5
		#(3)
		if (alu_out != 8)
			$display(“Failed OPC_JALR_5",alu_out);
		else 
			$display(“Passed OPC_JALR_5",alu_out);
	
		// Test Add
		#(3)
		funct5 = 5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b000; // FNC_ADD_SUB
		bit30 = 1'b0; //FNC2_ADD
		#(3)
		if (alu_out != 8)
			$display(“Failed FNC_ADD",alu_out);
		else 
			$display(“Passed FNC_ADD",alu_out);
		
		//Test Sub
		#(3)
		funct5 = 5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b000; // FNC_ADD_SUB
		bit30 = 1'b1; //FNC2_SUB
		#(3)
		if (alu_out != 2)
			$display("Failed FNC_SUB",alu_out);
		else 
			$display("Passed FNC_SUB",alu_out);
		
		//Test And
		#(3)
		funct5 = 5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b111; //FNC_AND
		op1 = 32'hFFFFFFFF;
		op2 = 32'h00000001;
		#(1)
		if (alu_out != 32'h00000001)
		$display("Failed FNC_AND", alu_out);
		else
		$display("Passed FNC_AND", alu_out);
		
		//Test OR
		#(3)
		funct5 = 5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b110; //FNC_OR
		op1 = 32'hFFFFFFFF;
		op2 = 32'h00000001;
		#(1)
		if (alu_out != 32'hFFFFFFFF)
		$display("Failed FNC_OR", alu_out);
		else
		$display("Passed FNC_OR", alu_out);
		
		//Test XOR
		#(3)
		funct5 =  5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b100; //FNC_XOR
		op1 = 32'hFFFFFFFF;
		op2 = 32'h00000001;
		#(1)
		if (alu_out != 32'hFFFFFFF0)
		$display("Failed FNC_XOR", alu_out);
		else
		$display("Passed FNC_XOR", alu_out);
		
		//Test SRA
		#(3)
		funct5 = 5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b101; //FNC_SRL_SRA
		bit30 = 1'b1; //FNC2_SRA;
		op1 = 32'hFFFFFFFF;
		op2 = 32'd2;
		#(1)
		if (alu_out != 32'hFFFFFFFF)
		$display("Failed FNC_SRA", alu_out);
		else
		$display("Passed FNC_SRA", alu_out);
		
		//Test SRL
		#(3)
		funct5 = 5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b101; //FNC_SRL_SRA
		bit30 = 1'b0;//FNC2_SRL
		op1 = 32'hFFFFFFFF;
		op2 = 32'd2;
		#(1)
		if (alu_out != 32'h3FFFFFFF)
		$display("Failed FNC_SRL", alu_out);
		else
		$display("Passed FNC_SRL", alu_out);
		
		//Test SLL
		#(3)
		funct5 =  5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b001; //FNC_SLL
		op1 = 32'hFFFFFFFF;
		op2 = 32'd2;
		#(1)
		if (alu_out != 32'hFFFFFFFC)
		$display("Failed FNC_SLL", alu_out);
		else
		$display("Passed FNC_SLL", alu_out);
		
		//Test SLT
		#(3)
		funct5 = 5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b010; //FNC_SLT
		op1 = -3;
		op2 = -4;
		#(1)
		if (alu_out != 0)
		$display("Failed FNC_SLT", alu_out);
		else
		$display("Passed FNC_SLT", alu_out);
		
		//Test SLTU
		#(3)
		funct5 = 5'b01100; //OPC_ARI_RTYPE_5
		funct3 = 3'b010;//FNC_SLTU
		op1 = 3;
		op2 = 4;
		#(1)
		if (alu_out != 1)
		$display("Failed FNC_SLTU", alu_out);
		else
		$display("Passed FNC_SLTU", alu_out);
	
		$finish();
		
	end
endmodule
