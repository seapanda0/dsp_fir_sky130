`timescale 1ps/1ps

module tb_dsp_fir();

    reg clk, rst;
    reg [7:0] ui_in;

    initial clk = 0;
    always #5 clk = ~clk;

    integer i;
    initial begin
        rst = 0; // Reset the module
        ui_in = 0;

        @(negedge clk);
        rst = 1; // Let the module start
        // Reset state, do nothing
        @(negedge clk);
        ui_in = 8'h11;
        @(negedge clk);
        ui_in = 8'h22;
        @(negedge clk);
        ui_in = 8'h33;
        @(negedge clk);
        ui_in = 8'h44;
        @(negedge clk);
        ui_in = 8'h55;
        @(negedge clk);
        ui_in = 8'h66;
        @(negedge clk);
        ui_in = 8'h77;
        @(negedge clk);
        ui_in = 8'h88;
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
        .ui_in(ui_in)
    );

endmodule