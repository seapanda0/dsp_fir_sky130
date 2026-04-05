`timescale 1ps/1ps

module tb_dsp_fir();

    localparam N_TAPS = 12;

    // Coefficients in Q1.7 format
    localparam signed [7:0] COEFF_0 = 8'sd1;
    localparam signed [7:0] COEFF_1 = 8'sd2;
    localparam signed [7:0] COEFF_2 = 8'sd7;
    localparam signed [7:0] COEFF_3 = 8'sd13;
    localparam signed [7:0] COEFF_4 = 8'sd19;
    localparam signed [7:0] COEFF_5 = 8'sd23;
    localparam signed [7:0] COEFF_6 = 8'sd23;
    localparam signed [7:0] COEFF_7 = 8'sd19;
    localparam signed [7:0] COEFF_8 = 8'sd13;
    localparam signed [7:0] COEFF_9 = 8'sd7;
    localparam signed [7:0] COEFF_10 = 8'sd2;
    localparam signed [7:0] COEFF_11 = 8'sd1;

    // Input testvectors
    localparam INPUT_VECTOR_SIZE = 256;
    reg [7:0] tv_input  [0:INPUT_VECTOR_SIZE-1];
    reg [7:0] tv_output [0:INPUT_VECTOR_SIZE-1];

    // Data to be hold for 8 rounds of calculation
    localparam DATA_IN_CONST = 8'h10;

    reg clk, rst, mode;
    reg [7:0] data_in;
    wire [7:0] data_out;

    initial clk = 0;
    always #5 clk = ~clk;

    integer i;
    integer idx; // Index for which in/out testvectors
    
    task wait_n_negedges;
        input integer n;
        begin
            repeat (n) @(negedge clk);
        end
    endtask

    initial begin

        $readmemh("test/input_vectors.hex", tv_input, 0, 255);
        $readmemh("test/output_vectors.hex", tv_output, 0, 255);

        rst = 0; // Reset the module
        data_in = 8'b0;
        mode = 0;

        // START OF COEFFICIENT LOADING MODE 

        @(negedge clk);
        rst = 1; // Let the module start
        mode = 1;
        data_in = COEFF_11; @(negedge clk);
        data_in = COEFF_10; @(negedge clk);
        data_in = COEFF_9;  @(negedge clk);
        data_in = COEFF_8;  @(negedge clk);
        data_in = COEFF_7;  @(negedge clk);
        data_in = COEFF_6;  @(negedge clk);
        data_in = COEFF_5;  @(negedge clk);
        data_in = COEFF_4;  @(negedge clk);
        data_in = COEFF_3;  @(negedge clk);
        data_in = COEFF_2;  @(negedge clk);
        data_in = COEFF_1;  @(negedge clk);
        data_in = COEFF_0;  @(negedge clk);
        
        // END OF COEFFICIENT LOADING MODE 

        $write("Time = %0t fir_coeff = \n", $time);
        $write("FIR Coefficients: ");
        for (i = 0; i < 12; i = i+1) begin
            $write("%0h ", m1.fir_coeff[i]);
        end
        $write("\n");

        // START FILTER MODE

        mode = 0;
        data_in = DATA_IN_CONST; // Hold the input constant for 12 rounds
        // Output should be same as input if Q1.7 format and coefficients sum to 1
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        
        $write("Time = %0t fir_coeff = ", $time);
        $write("Data Pipeline: ");
        for (i = 0; i < N_TAPS; i = i+1) begin
            $write("%0h ", m1.data_pipe[i]);
        end
        $write("\n");
        wait_n_negedges(6);
        // Check math, output should be equal to input if coefficients sum up to 1

        $write("Time = %0t fir_coeff = ", $time);
        $write("Data Pipeline: ");
        for (i = 0; i < N_TAPS; i = i+1) begin
            $write("%0h ", m1.data_pipe[i]);
        end
        $write("\n");
        $display("Data in: 8'h%0h | Data out: 8'h%0h", DATA_IN_CONST ,data_out);

        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        wait_n_negedges(6);
        
        for (i = 0; i < N_TAPS/2; i= i + 1) begin
            $display("State %0h Calculations: ", m1.phase);
            $display("%0h, %0h, %0h", m1.mux_c[0], m1.mux_d[0], m1.p0);
            $display("%0h, %0h, %0h", m1.mux_c[1], m1.mux_d[1], m1.p1);
            $display("Adder result %0h | Accumulated %0h ", m1.math_out, m1.acc);
            @(negedge clk);
        end

        // Feed in testvectors
        for (i = 0; i<= 40; i = i + 1) begin
            data_in = tv_input[i];
            @(negedge clk); 
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            $display("Rounds: %3d Data out: %0h", i ,data_out);
        end

        $stop;

    end

    dsp_fir m1 (
        .clk(clk),
        .rst_n(rst),
        .mode(mode),
        .data_in(data_in),
        .data_out(data_out)
    );
endmodule