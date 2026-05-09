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

    // Data to be hold for 8 rounds of calculation
    localparam DATA_IN_CONST = 8'hFF;

    reg clk, rst;
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

    // SPI Coefficients loading
    reg sclk, mosi, cs;
    initial sclk = ~0;
    always #30 sclk = ~sclk; // SPI clock should be 6-7 times slower than source clock

    task wait_n_negedges_sclk;
        input integer n;
        begin
            repeat (n) @(negedge sclk);
        end
    endtask

    initial begin

        $readmemh("test/input_vectors.hex", tv_input, 0, 255);
        $readmemh("test/output_vectors.hex", tv_output, 0, 255);

        rst = 0; // Reset the module
        data_in = 8'b0;

        sclk = 0;
        mosi = 0;
        cs = 1;
        @(negedge clk);

        // START OF COEFFICIENT LOADING MODE 

        rst = 1; // Let the module start
        cs = 0;

        for(i=7; i>=0; i = i - 1) begin
            mosi = COEFF_0[i];
            wait_n_negedges_sclk(1);
        end

        for(i=7; i>=0; i = i - 1) begin
            mosi = COEFF_1[i];
            wait_n_negedges_sclk(1);
        end

        for(i=7; i>=0; i = i - 1) begin
            mosi = COEFF_2[i];
            wait_n_negedges_sclk(1);
        end

        for(i=7; i>=0; i = i - 1) begin
            mosi = COEFF_3[i];
            wait_n_negedges_sclk(1);
        end

        for(i=7; i>=0; i = i - 1) begin
            mosi = COEFF_4[i];
            wait_n_negedges_sclk(1);
        end

        for(i=7; i>=0; i = i - 1) begin
            mosi = COEFF_5[i];
            wait_n_negedges_sclk(1);
        end
        for(i=7; i>=0; i = i - 1) begin
            mosi = COEFF_6[i];
            wait_n_negedges_sclk(1);
        end

        for(i=7; i>=0; i = i - 1) begin
            mosi = COEFF_7[i];
            wait_n_negedges_sclk(1);
        end
        // END OF COEFFICIENT LOADING MODE 

        $write("Time = %0t fir_coeff = \n", $time);
        $write("FIR Coefficients: ");
        for (i = 0; i < 8; i = i+1) begin
            $write("%0h ", m1.fir_coeff[i]);
        end
        $write("\n");

        // START FILTER MODE

        cs = 1;
        data_in = DATA_IN_CONST; // Hold the input constant for 8 rounds
        // Output should be same as input if Q1.7 format and coefficients sum to 1
        wait_n_negedges(8);
        wait_n_negedges(8);
        wait_n_negedges(8);
        wait_n_negedges(8);
        wait_n_negedges(8);
        wait_n_negedges(8);
        wait_n_negedges(8);
        
        $write("Time = %0t fir_coeff = ", $time);
        $write("Data Pipeline: ");
        for (i = 0; i < 8; i = i+1) begin
            $write("%0h ", m1.data_pipe[i]);
        end
        $write("\n");
        wait_n_negedges(8);

        // Check math, output should be equal to input if coefficients sum up to 1

        $write("Time = %0t fir_coeff = ", $time);
        $write("Data Pipeline: ");
        for (i = 0; i < 8; i = i+1) begin
            $write("%0h ", m1.data_pipe[i]);
        end
        $write("\n");
        $display("Data in: 8'h%0h | Data out: 8'h%0h", DATA_IN_CONST ,data_out);

        wait_n_negedges(8);

        for (i = 0; i < 8; i= i + 1) begin
            $display("State %0h Calculations: ", m1.phase);
            $display("%0h, %0h, %0h", m1.mux_c, m1.mux_d, m1.p0);
            @(negedge clk);
        end

        // Feed in testvectors
        for (i = 0; i<= 40; i = i + 1) begin
            data_in = tv_input[i];
            wait_n_negedges(8);

            $display("Rounds: %3d Data out: %0h", i ,data_out);
        end

        $finish;

    end

    dsp_fir m1 (
        .clk(clk),
        .rst_n(rst),
        .data_in(data_in),
        .data_out(data_out),
        .spi_cs(cs),
        .spi_mosi(mosi),
        .spi_sclk(sclk)
    );
endmodule