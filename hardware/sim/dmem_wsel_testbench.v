`timescale 1ns / 1ns

module dmem_wsel_testbench;
    reg [31:0] addr;
    reg [31:0] reg_rs2;
    reg we;
    reg [4:0] funct5;
    reg [2:0] funct3;
    reg pc30;
    wire [31:0] data;
    wire [3:0] dmem_wea;
    wire [3:0] imem_wea;
    wire uart_we;
    wire counter_reset;
    wire leds_we;
    
    dmem_wsel test(
        .addr(addr),
        .reg_rs2(reg_rs2),
        .we(we),
        .funct5(funct5),
        .funct3(funct3),
        .pc30(pc30),
        .data(data),
        .dmem_wea(dmem_wea),
        .imem_wea(imem_wea),
        .uart_we(uart_we),
        .counter_reset(counter_reset),
        .leds_we(leds_we)
    );
    
    initial begin
        //test SB + dmem
        reg_rs2 = 32'b00001000_00000100_00000010_00000001;
        we = 1'b1;
        funct5 = 5'b01000;
        addr = 32'b0001_00000000000000_000000000000_10;
        funct3 = 3'b000;
        pc30 = 1'b0;
        #(3)
        if (data != 32'b00000000_00000001_00000000_00000000)
			$display("Failed SB data:%b",data);
		else 
			$display("Passed SB data:%b",data);
		
		if (dmem_wea != 4'b0100 || imem_wea != 4'b0 || uart_we !=0  || counter_reset !=0  || leds_we !=0 )
			$display("Failed SB write back,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
		else 
			$display("Passed SB write back,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
		
		//test SH +dmem + imem
		#(3)
	    addr = 32'b0011_00000000000000_000000000000_00;
        funct3 = 3'b001;
        pc30 = 1'b1;
        #(3)
        if (data != 32'b00000000_00000000_00000010_00000001)
			$display("Failed SH data:%b",data);
		else 
			$display("Passed SH data:%b",data);
		
		if (dmem_wea != 4'b0011 || imem_wea != 4'b0011 || uart_we !=0  || counter_reset !=0  || leds_we !=0 )
			$display("Failed SH write back,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
		else 
			$display("Passed SH write back,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
		
		//test SW + UART
		#(3)
	    addr = 32'h80000008;
        funct3 = 3'b010;
        #(3)
        if (data != 32'b00001000_00000100_00000010_00000001)
			$display("Failed SW data:%b",data);
		else 
			$display("Passed SW data:%b",data);
		
		if (dmem_wea != 4'b0000 || imem_wea != 4'b0000 || uart_we !=1  || counter_reset !=0  || leds_we !=0 )
			$display("Failed UART,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
		else 
			$display("Passed UART,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
	   
	   //test Reset counters
		#(3)
	    addr = 32'h80000018;
        #(3)
		
		if (dmem_wea != 4'b0000 || imem_wea != 4'b0000 || uart_we !=0  || counter_reset !=1  || leds_we !=0 )
			$display("Failed Reset counters,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
		else 
			$display("Passed Reset counters,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
			
		 //test LED
		#(3)
	    addr = 32'h80000030;
        #(3)
        
		if (dmem_wea != 4'b0000 || imem_wea != 4'b0000 || uart_we !=0  || counter_reset !=0  || leds_we !=1 )
			$display("Failed LED,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
		else 
			$display("Passed LED,dmem_wea:%b,imem_wea:%b, uart_we:%b, counter_reset:%b, leds_we:%b ",dmem_wea,imem_wea, uart_we, counter_reset, leds_we);
	
	    $finish();
    end
endmodule