`timescale 1ns / 1ns

module load_extend_testbench;
    reg [31:0] din;
    reg [1:0] addr;
    reg [2:0] funct3;
    wire [31:0] dout;
    
    load_extend load_extend_test(
        .din(din),
        .addr(addr),
        .funct3(funct3),
        .dout(dout)
    );
    
    initial begin
        din = 32'b10001000_10000100_00000010_00000001;
        
        //test FNC_LB
        funct3 = 3'b000;
        addr = 2'b00;
        #(1)
        if (dout != 32'b00000000_00000000_00000000_00000001)
			$display("Failed FNC_LB_00:%b",dout);
		else 
			$display("Passed FNC_LB_00:%b",dout);
			
		#(1)
		addr = 2'b01;
        #(1)
        if (dout != 32'b00000000_00000000_00000000_00000010)
			$display("Failed FNC_LB_01:%b",dout);
		else 
			$display("Passed FNC_LB_01:%b",dout);
			
		#(1)
		addr = 2'b10;
        #(1)
        if (dout != 32'b11111111_11111111_11111111_10000100)
			$display("Failed FNC_LB_10:%b",dout);
		else 
			$display("Passed FNC_LB_10:%b",dout);
			
		#(1)
		addr = 2'b11;
        #(1)
        if (dout != 32'b11111111_11111111_11111111_10001000)
			$display("Failed FNC_LB_11:%b",dout);
		else 
			$display("Passed FNC_LB_11:%b",dout);
		
		//test FNC_LBU	
		funct3 = 3'b100;
        addr = 2'b00;
        #(1)
        if (dout != 32'b00000000_00000000_00000000_00000001)
			$display("Failed FNC_LBU_00:%b",dout);
		else 
			$display("Passed FNC_LBU_00:%b",dout);
			
		#(1)
		addr = 2'b01;
        #(1)
        if (dout != 32'b00000000_00000000_00000000_00000010)
			$display("Failed FNC_LBU_01:%b",dout);
		else 
			$display("Passed FNC_LBU_01:%b",dout);
			
		#(1)
		addr = 2'b10;
        #(1)
        if (dout != 32'b00000000_00000000_00000000_10000100)
			$display("Failed FNC_LBU_10:%b",dout);
		else 
			$display("Passed FNC_LBU_10:%b",dout);
			
		#(1)
		addr = 2'b11;
        #(1)
        if (dout != 32'b00000000_00000000_00000000_10001000)
			$display("Failed FNC_LBU_11:%b",dout);
		else 
			$display("Passed FNC_LBU_11:%b",dout);
			
		//test FNC_LH	
		funct3 = 3'b001;
        addr = 2'b00;
        #(1)
        if (dout != 32'b00000000_00000000_00000010_00000001)
			$display("Failed FNC_LH_00:%b",dout);
		else 
			$display("Passed FNC_LH_00:%b",dout);
			
		#(1)
		addr = 2'b10;
        #(1)
        if (dout != 32'b11111111_11111111_10001000_10000100)
			$display("Failed FNC_LH_10:%b",dout);
		else 
			$display("Passed FNC_LH_10:%b",dout);
		
		//test FNC_LHU		
		funct3 = 3'b101;
        addr = 2'b00;
        #(1)
        if (dout != 32'b00000000_00000000_00000010_00000001)
			$display("Failed FNC_LHU_00:%b",dout);
		else 
			$display("Passed FNC_LHU_00:%b",dout);
			
		#(1)
		addr = 2'b10;
        #(1)
        if (dout != 32'b00000000_00000000_10001000_10000100)
			$display("Failed FNC_LHU_10:%b",dout);
		else 
			$display("Passed FNC_LHU_10:%b",dout);
			
		//test FNC_LW		
		funct3 = 3'b010;
        addr = 2'b00;
        #(1)
        if (dout != 32'b10001000_10000100_00000010_00000001)
			$display("Failed FNC_LW:%b",dout);
		else 
			$display("Passed FNC_LW:%b",dout);
		
		$finish();
        
    end
endmodule