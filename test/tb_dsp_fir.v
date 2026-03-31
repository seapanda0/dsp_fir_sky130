`timescale 1ps/1ps

module tb_dsp_fir();

    // Coefficients in Q1.7 format
    localparam signed [7:0] COEFF_0 = 8'sd2;
    localparam signed [7:0] COEFF_1 = 8'sd8;
    localparam signed [7:0] COEFF_2 = 8'sd21;
    localparam signed [7:0] COEFF_3 = 8'sd33;
    localparam signed [7:0] COEFF_4 = 8'sd33;
    localparam signed [7:0] COEFF_5 = 8'sd21;
    localparam signed [7:0] COEFF_6 = 8'sd8;
    localparam signed [7:0] COEFF_7 = 8'sd2;

    // Input testvectors
    localparam INPUT_VECTOR_SIZE = 256;
    reg [7:0] tv_input  [0:INPUT_VECTOR_SIZE-1];
    reg [7:0] tv_output [0:INPUT_VECTOR_SIZE-1];

    reg clk, rst, mode;
    reg [7:0] data_in;
    wire [7:0] data_out;



    initial clk = 0;
    always #5 clk = ~clk;

    integer i;
    integer idx; // Index for which in/out data until this point

    initial begin

        $readmemh("test/fir_input_vector.txt", tv_input, 0, 255);
        $readmemh("test/fir_output_vector.txt", tv_output, 0, 255);

        rst = 0; // Reset the module
        data_in = 8'b0;
        mode = 0;

        // START OF COEFFICIENT LOADING MODE 

        @(negedge clk);
        rst = 1; // Let the module start
        mode = 1;
        data_in = COEFF_7; @(negedge clk);
        data_in = COEFF_6; @(negedge clk);
        data_in = COEFF_5; @(negedge clk);
        data_in = COEFF_4; @(negedge clk);
        data_in = COEFF_3; @(negedge clk);
        data_in = COEFF_2; @(negedge clk);
        data_in = COEFF_1; @(negedge clk);
        data_in = COEFF_0; @(negedge clk);
        
        // END OF COEFFICIENT LOADING MODE 

        $write("Time = %0t fir_coeff = \n", $time);
        $write("FIR Coefficients: ");
        for (i = 0; i < 8; i = i+1) begin
            $write("%0h ", m1.fir_coeff[i]);
        end
        $write("\n");

        // START FILTER MODE

        mode = 0;
        data_in = 8'h10; // Hold the input constant for 8 rounds
        // Output should be same as input if Q1.7 format and coefficients sum to 1
        @(negedge clk); @(negedge clk);
        @(negedge clk); @(negedge clk);
        @(negedge clk); @(negedge clk);
        @(negedge clk); @(negedge clk);
        @(negedge clk); @(negedge clk);
        @(negedge clk); @(negedge clk);
        @(negedge clk); @(negedge clk);
        
        $write("Time = %0t fir_coeff = ", $time);
        $write("Data Pipeline: ");
        for (i = 0; i < 8; i = i+1) begin
            $write("%0h ", m1.data_pipeline[i]);
        end
        $write("\n");
        @(negedge clk); @(negedge clk);

        // Check math, output should be equal to input if coefficients sum up to 1

        $write("Time = %0t fir_coeff = ", $time);
        $write("Data Pipeline: ");
        for (i = 0; i < 8; i = i+1) begin
            $write("%0h ", m1.data_pipeline[i]);
        end
        $write("\n");
        $display("State %0h", m1.state_q);
        $display("%0h, %0h, %0h", m1.m1.a0, m1.m1.b0, m1.m1.out0);
        $display("%0h, %0h, %0h", m1.m1.a1, m1.m1.b1, m1.m1.out1);
        $display("%0h, %0h, %0h", m1.m1.a2, m1.m1.b2, m1.m1.out2);
        $display("%0h, %0h, %0h", m1.m1.a3, m1.m1.b3, m1.m1.out3);
        $display("Adder result %0h", m1.result_adder_d);
        @(negedge clk);

        $write("Time = %0t fir_coeff = ", $time);
        $write("Data Pipeline: ");
        for (i = 0; i < 8; i = i+1) begin
            $write("%0h ", m1.data_pipeline[i]);
        end
        $write("\n");
        $display("State %0h", m1.state_q);
        $display("%0h, %0h, %0h", m1.m1.a0, m1.m1.b0, m1.m1.out0);
        $display("%0h, %0h, %0h", m1.m1.a1, m1.m1.b1, m1.m1.out1);
        $display("%0h, %0h, %0h", m1.m1.a2, m1.m1.b2, m1.m1.out2);
        $display("%0h, %0h, %0h", m1.m1.a3, m1.m1.b3, m1.m1.out3);
        $display("Adder result %0h", m1.result_adder_d);
        
        // Next M1 state ready

        // for (i = 0; i<= 20; i = i + 1) begin
        //     data_in = tv_input[i];
        //     @(negedge clk); 
        //     @(negedge clk);
        //     $display("Rounds: %3d Data out: %0h", i ,data_out);

        // end
        

        @(negedge clk); @(negedge clk);
        // @(negedge clk); @(negedge clk);

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