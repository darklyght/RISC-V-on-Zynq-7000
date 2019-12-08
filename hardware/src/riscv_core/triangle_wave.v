module triangle_wave (
    input clk,
    input rst,
    input in_valid,
    input [23:0] phase_1,
    input [23:0] phase_2,
    input [23:0] phase_3,
    input [23:0] phase_4,
    output [20:0] wave_1,
    output [20:0] wave_2,
    output [20:0] wave_3,
    output [20:0] wave_4,
    output out_valid
);
    
    wire [9:0] phase_1_in;
    wire [9:0] phase_1_in_d;
    wire [7:0] addr_1;
    wire [7:0] addr_1_d;
    reg [14:0] residue_1;

    wire [9:0] phase_2_in;
    wire [9:0] phase_2_in_d;
    wire [7:0] addr_2;
    wire [7:0] addr_2_d;
    reg [14:0] residue_2;
    
    wire [9:0] phase_3_in;
    wire [9:0] phase_3_in_d;
    wire [7:0] addr_3;
    wire [7:0] addr_3_d;
    reg [14:0] residue_3;  

    wire [9:0] phase_4_in;
    wire [9:0] phase_4_in_d;
    wire [7:0] addr_4;
    wire [7:0] addr_4_d;
    reg [14:0] residue_4;

    reg [6:0] phase;
    reg [7:0] lut_addra;
    reg [7:0] lut_addrb;
    wire [20:0] lut_douta;
    wire [20:0] lut_doutb;    

    reg [20:0] lut_douta_1;
    reg [20:0] lut_doutb_1;
    reg [20:0] lut_douta_2;
    reg [20:0] lut_doutb_2;
    reg [20:0] lut_douta_3;
    reg [20:0] lut_doutb_3;
    reg [20:0] lut_douta_4;
    reg [20:0] lut_doutb_4;

    reg [20:0] diff_1;
    reg [20:0] diff_2;
    reg [20:0] diff_3;
    reg [20:0] diff_4;

    reg [20:0] wave_out_1;
    reg [20:0] wave_out_2; 
    reg [20:0] wave_out_3; 
    reg [20:0] wave_out_4;

    wire [36:0] mult_1;
    wire [36:0] mult_2;
    wire [36:0] mult_3;
    wire [36:0] mult_4;

    triangle_lut triangle_lut (
        .clk(clk),
        .ena(|{phase[3:0], in_valid}),
        .addra(lut_addra),
        .douta(lut_douta),
        .enb(|{phase[3:0], in_valid}),
        .addrb(lut_addrb),
        .doutb(lut_doutb)
    );

    assign phase_1_in = phase_1[23:14];
    assign phase_1_in_d = phase_1_in + 10'b1;
    assign addr_1 = phase_1_in[8] == 1'b0 ? phase_1_in[7:0] : 8'd255 - phase_1_in[7:0];
    assign addr_1_d = phase_1_in_d[8] == 1'b0 ? phase_1_in_d[7:0] : 8'd255 - phase_1_in_d[7:0];
    
    assign phase_2_in = phase_2[23:14];
    assign phase_2_in_d = phase_2_in + 10'b1;
    assign addr_2 = phase_2_in[8] == 1'b0 ? phase_2_in[7:0] : 8'd255 - phase_2_in[7:0];
    assign addr_2_d = phase_2_in_d[8] == 1'b0 ? phase_2_in_d[7:0] : 8'd255 - phase_2_in_d[7:0];

    assign phase_3_in = phase_3[23:14];
    assign phase_3_in_d = phase_3_in + 10'b1;
    assign addr_3 = phase_3_in[8] == 1'b0 ? phase_3_in[7:0] : 8'd255 - phase_3_in[7:0];
    assign addr_3_d = phase_3_in_d[8] == 1'b0 ? phase_3_in_d[7:0] : 8'd255 - phase_3_in_d[7:0];

    assign phase_4_in = phase_4[23:14];
    assign phase_4_in_d = phase_4_in + 10'b1;
    assign addr_4 = phase_4_in[8] == 1'b0 ? phase_4_in[7:0] : 8'd255 - phase_4_in[7:0];
    assign addr_4_d = phase_4_in_d[8] == 1'b0 ? phase_4_in_d[7:0] : 8'd255 - phase_4_in_d[7:0];

    assign mult_1 = $signed(residue_1) * $signed(diff_1);
    assign mult_2 = $signed(residue_2) * $signed(diff_2);
    assign mult_3 = $signed(residue_3) * $signed(diff_3);
    assign mult_4 = $signed(residue_4) * $signed(diff_4);

    always @ (posedge clk) begin
        if (rst)
            phase <= 7'b0;
        else
            phase <= {phase[5:0], in_valid};
    end

    always @ (posedge clk) begin
        if (rst) begin
            residue_1 <= 15'b0;
            residue_2 <= 15'b0;
            residue_3 <= 15'b0;
            residue_4 <= 15'b0;
        end else begin
            if (in_valid) begin
                residue_1 <= {1'b0, phase_1[13:0]};
                residue_2 <= {1'b0, phase_2[13:0]};
                residue_3 <= {1'b0, phase_3[13:0]};
                residue_4 <= {1'b0, phase_4[13:0]};
            end
        end
    end

    always @ (*) begin
        case ({phase[2:0], in_valid})
            4'b0001: begin
                lut_addra = addr_1;
                lut_addrb = addr_1_d;
            end
            4'b0010: begin
                lut_addra = addr_2;
                lut_addrb = addr_2_d;
            end
            4'b0100: begin
                lut_addra = addr_3;
                lut_addrb = addr_3_d;
            end    
            4'b1000: begin
                lut_addra = addr_4;
                lut_addrb = addr_4_d;
            end
            default: begin
                lut_addra = addr_1;
                lut_addrb = addr_1_d;
            end
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            lut_douta_1 <= 21'b0;
            lut_doutb_1 <= 21'b0;
            lut_douta_2 <= 21'b0;
            lut_doutb_2 <= 21'b0;
            lut_douta_3 <= 21'b0;
            lut_doutb_3 <= 21'b0;
            lut_douta_4 <= 21'b0;
            lut_doutb_4 <= 21'b0;
        end else begin
            case (phase[3:0])
                4'b0001: begin
                    lut_douta_1 <= phase_1_in[9] == 1'b0 ? lut_douta : -lut_douta;
                    lut_doutb_1 <= phase_1_in_d[9] == 1'b0 ? lut_doutb : -lut_doutb;
                end
                4'b0010: begin
                    lut_douta_2 <= phase_2_in[9] == 1'b0 ? lut_douta : -lut_douta;
                    lut_doutb_2 <= phase_2_in_d[9] == 1'b0 ? lut_doutb : -lut_doutb;
                end
                4'b0100: begin
                    lut_douta_3 <= phase_3_in[9] == 1'b0 ? lut_douta : -lut_douta;
                    lut_doutb_3 <= phase_3_in_d[9] == 1'b0 ? lut_doutb : -lut_doutb;
                end
                4'b1000: begin
                    lut_douta_4 <= phase_4_in[9] == 1'b0 ? lut_douta : -lut_douta;
                    lut_doutb_4 <= phase_4_in_d[9] == 1'b0 ? lut_doutb : -lut_doutb;
                end
                default: begin
                    lut_douta_1 <= lut_douta_1;
                    lut_doutb_1 <= lut_doutb_1;
                    lut_douta_2 <= lut_douta_2;
                    lut_doutb_2 <= lut_doutb_2;
                    lut_douta_3 <= lut_douta_3;
                    lut_doutb_3 <= lut_doutb_3;
                    lut_douta_4 <= lut_douta_4;
                    lut_doutb_4 <= lut_doutb_4;
                end
            endcase
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            diff_1 <= 21'b0;
            diff_2 <= 21'b0;
            diff_3 <= 21'b0;
            diff_4 <= 21'b0;
        end else begin
            if (phase[4]) begin
                diff_1 <= lut_doutb_1 - lut_douta_1;
                diff_2 <= lut_doutb_2 - lut_douta_2;
                diff_3 <= lut_doutb_3 - lut_douta_3;
                diff_4 <= lut_doutb_4 - lut_douta_4;
            end
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            wave_out_1 <= 21'b0;
            wave_out_2 <= 21'b0;
            wave_out_3 <= 21'b0;
            wave_out_4 <= 21'b0;
        end else begin
            if (phase[5]) begin
                wave_out_1 <= lut_douta_1 + mult_1[34:14];
                wave_out_2 <= lut_douta_2 + mult_2[34:14];
                wave_out_3 <= lut_douta_3 + mult_3[34:14];
                wave_out_4 <= lut_douta_4 + mult_4[34:14];
            end
        end
    end
    
    assign out_valid = phase[6];
    assign wave_1 = wave_out_1;
    assign wave_2 = wave_out_2;
    assign wave_3 = wave_out_3;
    assign wave_4 = wave_out_4;
    
endmodule
