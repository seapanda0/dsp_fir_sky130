/*
 * Module `SPISlave`
 *
 * Based on the SPISlave module from the tt09-firEngine Tiny Tapeout project.
 * Original author: arandomdev
 * License: Apache-2.0
 *
 * Modifications:
 * - Adapted from SystemVerilog to Verilog
 */

 module SPISlave(
    input wire clk,
    input wire rst_n,

    output reg serialOut,
    output reg serialEn,

    input wire rawSCLK,
    input wire rawMOSI,
    input wire rawCS
 );
    reg [2:0] sclkSynchronizer;
    reg [1:0] mosiSynchronizer;
    reg [1:0] csSynchronizer;

    wire sclkRe = sclkSynchronizer[2:1] == 2'b01;
    wire mosi = mosiSynchronizer[1];
    wire cs = csSynchronizer[1];

    always @(posedge clk) begin
        if (!rst_n) begin
            sclkSynchronizer <= 0;
            mosiSynchronizer <= 0;
            csSynchronizer <= 0;
        end
        else begin
            sclkSynchronizer <= {sclkSynchronizer[1:0], rawSCLK};
            mosiSynchronizer <= {mosiSynchronizer[0], rawMOSI};
            csSynchronizer <= {csSynchronizer[0], rawCS};
        end
    end

    always @(*) begin
        if (!cs && sclkRe) begin
            serialOut = mosi;
            serialEn = 1;
        end else begin
            serialOut = 0;
            serialEn = 0;
        end
    end
    
 endmodule