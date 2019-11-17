`timescale 1ns / 1ns

module imm_gen_testbench;
    reg [31:2] inst;
    wire [31:0] imm;
    
    imm_gen imm_gen_test(
        .inst(inst),
        .imm(imm)
    );
    
    initial begin
        //test OPC_ARI_ITYPE_5
        inst = 32'b111111001110_00001_000_01111_00100;
        #(3)
		if ($signed(imm) != -50)
			$display("Failed OPC_ARI_ITYPE_5:%b", imm);
		else 
			$display("Passed OPC_ARI_ITYPE_5:%b", imm);
			
	   #(3)
	   //test OPC_LOAD_5  
	   inst = 32'b000000001000_00010_010_01110_00000;
        #(3)
		if ($signed(imm) != 8)
			$display("Failed OPC_LOAD_5:%b", imm);
		else 
			$display("Passed OPC_LOAD_5:%b", imm);
        
        #(3)
	   //test OPC_STORE_5  
	   inst = 32'b0000000_01110_00010_010_01000_01000;
        #(3)
		if ($signed(imm) != 8)
			$display("Failed OPC_STORE_5:%b", imm);
		else 
			$display("Passed OPC_STORE_5:%b", imm);
			
		#(3)
	   //test OPC_BRANCH_5  
	   inst = 32'b0_000000_01010_10011_000_1000_0_11000;
        #(3)
		if ($signed(imm) != 16)
			$display("Failed OPC_BRANCH_5:%b", imm);
		else 
			$display("Passed OPC_BRANCH_5:%b", imm);
			
	   #(3)
	   //test OPC_JALR_5  
	   inst = 32'b000000001000_00010_000_01110_11001;
        #(3)
		if ($signed(imm) != 8)
			$display("Failed OPC_JALR_5:%b", imm);
		else 
			$display("Passed OPC_JALR_5:%b", imm);
		
		//test OPC_JAL_5  
	   inst = 32'b0_1011011000_1_11110000_00101_11011;
        #(3)
		if (imm != 32'b0_11110000_1_1011011000_0)
			$display("Failed OPC_JAL_5:%b", imm);
		else 
			$display("Passed OPC_JAL_5:%b", imm);
		
		//test OPC_AUIPC_5  
	   inst = 32'b00000000010000001001_00101_00101;
        #(3)
		if (imm != 32'b00000000010000001001_000000000000)
			$display("Failed OPC_AUIPC_5:%b", imm);
		else 
			$display("Passed OPC_AUIPC_5:%b", imm);	
		
		//test OPC_LUI_5  
	   inst = 32'b00000000010000001001_00101_01101;
        #(3)
		if (imm != 32'b00000000010000001001_000000000000)
			$display("Failed OPC_LUI_5:%b", imm);
		else 
			$display("Passed OPC_LUI_5:%b", imm);
			
		//test OPC_CSR_5  
	   inst = 32'b010000110101_00111_000_11000_11100;
        #(3)
		if (imm != 32'b00111)
			$display("Failed OPC_CSR_5:%b", imm);
		else 
			$display("Passed OPC_CSR_5:%b", imm);	
		
		$finish();
    end
endmodule