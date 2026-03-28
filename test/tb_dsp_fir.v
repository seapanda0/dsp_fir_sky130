`timescale 1ps/1ps

module tb_dsp_fir();

    reg clk, rst, mode;
    reg [7:0] data_in;

    initial clk = 0;
    always #5 clk = ~clk;

    integer i;
    initial begin
        rst = 0; // Reset the module
        data_in = 8'b0;
        mode = 0;
        @(negedge clk);
        rst = 1; // Let the module start
        mode = 1;
        data_in = 8'h11;
        @(negedge clk);
        data_in = 8'h22;
        @(negedge clk);
        data_in = 8'h33;
        @(negedge clk);
        data_in = 8'h44;
        @(negedge clk);
        data_in = 8'h55;
        @(negedge clk);
        data_in = 8'h66;
        @(negedge clk);
        data_in = 8'h77;
        @(negedge clk);
        data_in = 8'h88;
        @(negedge clk);
        mode = 0;
        @(negedge clk);
        #5;
        $write("Time = %0t fir_coeff = ", $time);
        for (i = 0; i < 8; i = i+1) begin
            $write("%0h ", m1.fir_coeff[i]);
        end
        $write("\n");
        $stop;
    end

    dsp_fir m1 (
        .clk(clk),
        .rst_n(rst),
        .mode(mode),
        .data_in(data_in)
    );
endmodule