module sine_wave (
    input clk,
    input rst,
    input in_valid,
    input [11:0] phase,
    output [20:0] wave,
    output reg out_valid
);
    
    wire [11:0] phase_d;
    wire [7:0] addr;
    wire [7:0] addr_d;
    reg [11:0] phase_reg;
    reg [11:0] phase_d_reg;
    wire [20:0] out;
    wire [20:0] out_d;
    wire [20:0] out_c;
    wire [20:0] out_d_c;
    wire [3:0] p;
    wire [3:0] n;
    reg [1:0] residue;
    reg valid_reg;
    reg [24:0] wave_reg;
    
    assign phase_d = (phase[9:2] != 8'hFF) ? phase + 12'b100 : phase;
    assign addr = phase[10] == 1'b0 ? phase[9:2] : 8'd255 - phase[9:2];
    assign addr_d = phase[10] == 1'b0 ? phase_d[9:2] : 8'd255 - phase_d[9:2];

    sine_lut sine_lut (
        .clk(clk),
        .ena(in_valid),
        .addra(addr),
        .douta(out),
        .enb(in_valid),
        .addrb(addr_d),
        .doutb(out_d)
    );
    
    always @ (posedge clk) begin
        if (rst) begin
            phase_reg <= 12'b0;
            phase_d_reg <= 12'b0;
        end else begin
            phase_reg <= phase;
            phase_d_reg <= phase_d;
        end
    end

    assign out_c = phase_reg[11] == 1'b0 ? out : -out;
    assign out_d_c = phase_d_reg[11] == 1'b0 ? out_d : -out_d;

    always @ (posedge clk) begin
        if (rst) begin
            valid_reg <= 1'b0;
            residue <= 2'b0;
        end else begin
            valid_reg <= in_valid;
            if (in_valid)
                residue <= phase[1:0];
        end
    end
    
    assign p = {2'b00, residue};
    assign n = 4'b0100 - {2'b00, residue};
    
    always @ (posedge clk) begin
        if (rst) begin
            out_valid <= 1'b0;
            wave_reg <= 25'b0;
        end else begin
            out_valid <= valid_reg;
            if (valid_reg)
                wave_reg <= $signed(out_c) * $signed(n) + $signed(out_d_c) * $signed(p);
        end
    end
    
    assign wave = wave_reg[22:2];
    
endmodule
