module debouncer #(
    parameter width = 1,
    parameter sample_count_max = 25000,
    parameter pulse_count_max = 150,
    parameter wrapping_counter_width = $clog2(sample_count_max),
    parameter saturating_counter_width = $clog2(pulse_count_max))
(
    input clk,
    input [width-1:0] glitchy_signal,
    output [width-1:0] debounced_signal
);
    // Create your debouncer circuit
    // The debouncer takes in a bus of 1-bit synchronized, but glitchy signals
    // and should output a bus of 1-bit signals that hold high when their respective counter saturates

    // Remove this line once you create your synchronizer
    
    genvar i;
    
    wire sample_pulse;
    reg [wrapping_counter_width-1:0] wrapping_counter = 'b0;
    reg [saturating_counter_width-1:0] saturating_counter [width-1:0];
    
    generate
        for (i = 0; i < width; i = i + 1) begin
            initial begin
                saturating_counter[i] = 'b0;
            end
        end
    endgenerate
    
    always @ (posedge clk) begin
        wrapping_counter <= wrapping_counter + 'b1;
        /* verilator lint_off WIDTH */
        if (wrapping_counter == sample_count_max) begin
        /* verilator lint_on WIDTH */
            wrapping_counter <= 'b0;
        end
    end
    /* verilator lint_off WIDTH */
    assign sample_pulse = wrapping_counter == sample_count_max;
    /* verilator lint_on WIDTH */
    generate
        for (i = 0; i < width; i = i + 1) begin
            always @ (posedge clk) begin
                /* verilator lint_off WIDTH */
                if (glitchy_signal[i] == 1'b1 && sample_pulse == 1'b1 && saturating_counter[i] < pulse_count_max) begin
                /* verilator lint_on WIDTH */
                    saturating_counter[i] <= saturating_counter[i] + 'b1;
                end else if (glitchy_signal[i] == 1'b0) begin
                    saturating_counter[i] <= 'b0;
                end
            end
            /* verilator lint_off WIDTH */
            assign debounced_signal[i] = saturating_counter[i] == pulse_count_max;
            /* verilator lint_on WIDTH */
        end
    endgenerate
    
endmodule
