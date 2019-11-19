`timescale 1ns / 1ns

module branch_pred_testbench();
    reg clk;
	initial clk = 0;
	always #(4) clk = ~clk;
    reg rst;
    reg [31:0] pc;
    reg [31:0] imm;
    reg [6:2] inst;
    reg branch;
    reg result;
    wire predict;
    wire [31:0] next_pc;    
    
    branch_pred test(
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .imm(imm),
        .inst(inst),
        .branch(branch),
        .result(result),
        .predict(predict),
        .next_pc(next_pc)        
    );
    
    initial begin
        rst = 1'b1;
        #(5)
        
        rst = 1'b0;
        pc = 32'd0;
        imm = 32'd2;
        branch = 1'b1;
        result = 1'b1;
        inst = 5'b11000; // `OPC_BRANCH_5
        #(3)
        if( ~predict && next_pc == 32'd2)
            $display("Test 1 passed:  branch:1, result:1, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 1 failed:  branch:1, result:1, predict =:%b, next_pc =:%b", predict, next_pc);
        
        #(3)
        branch = 1'b1;
        result = 1'b1;   
        #(3)
        if( ~predict && next_pc == 32'd2)
            $display("Test 2 passed:  branch:11, result:11, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 2 failed:  branch:11, result:11, predict =:%b, next_pc =:%b", predict, next_pc);
        
        #(3)
        branch = 1'b1;
        result = 1'b1;   
        #(3)
        if( predict && next_pc == 32'd2)
            $display("Test 3 passed:  branch:111, result:111, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 3 failed:  branch:111, result:111, predict =:%b, next_pc =:%b", predict, next_pc);
        
        #(3)
        branch = 1'b1;
        result = 1'b1;   
        #(3)
        if( predict && next_pc == 32'd2)
            $display("Test 4 passed:  branch:1111, result:1111, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 4 failed:  branch:1111, result:1111, predict =:%b, next_pc =:%b", predict, next_pc);
        
        #(3)
        branch = 1'b1;
        result = 1'b1;   
        #(3)
        if( predict && next_pc == 32'd2)
            $display("Test 5 passed:  branch:11111, result:11111, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 5 failed:  branch:11111, result:11111, predict =:%b, next_pc =:%b", predict, next_pc);
        
        #(3)
        branch = 1'b1;
        result = 1'b1;   
        #(3)
        if( predict && next_pc == 32'd2)
            $display("Test 5 passed:  branch:111111, result:111111, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 5 failed:  branch:111111, result:111111, predict =:%b, next_pc =:%b", predict, next_pc);
        
        #(3)
        branch = 1'b1;
        result = 1'b0;   
        #(3)
        if( predict && next_pc == 32'd2)
            $display("Test 5 passed:  branch:1111111, result:1111110, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 5 failed:  branch:1111111, result:1111110, predict =:%b, next_pc =:%b", predict, next_pc);
        
        #(3)
        branch = 1'b1;
        result = 1'b0;   
        #(3)
        if( predict && next_pc == 32'd2)
            $display("Test 5 passed:  branch:11111111, result:11111100, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 5 failed:  branch:11111111, result:11111100, predict =:%b, next_pc =:%b", predict, next_pc);
        
        #(3)
        branch = 1'b1;
        result = 1'b0;   
        #(3)
        if( predict && next_pc == 32'd2)
            $display("Test 5 passed:  branch:111111111, result:111111000, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 5 failed:  branch:111111111, result:111111000, predict =:%b, next_pc =:%b", predict, next_pc);
        
        #(3)
        branch = 1'b1;
        result = 1'b0;   
        #(3)
        if( predict && next_pc == 32'd2)
            $display("Test 5 passed:  branch:1111111111, result:1111110000, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 5 failed:  branch:1111111111, result:1111110000, predict =:%b, next_pc =:%b", predict, next_pc);
        
         #(3)
        branch = 1'b1;
        result = 1'b1;   
        #(3)
        if( predict && next_pc == 32'd2)
            $display("Test 5 passed:  branch:1111111111, result:11111100001, predict =:%b, next_pc =:%b", predict, next_pc);
        else 
            $display("Test 5 failed:  branch:1111111111, result:11111100001, predict =:%b, next_pc =:%b", predict, next_pc);
        
		$finish();
    end
endmodule