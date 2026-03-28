`default_nettype none

module tt_um_factory_test (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  
  dsp_fir m1 (
    .data_in(ui_in),
    .data_out(uo_out),
    .mode(uio_in[0]),
    .clk(clk),
    .rst_n(rst_n)
  );
  // avoid linter warning about unused pins:
  wire _unused_pins = &{ena, uio_out, uio_oe, uio_in[7:1],1'b0};
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

endmodule  // tt_um_factory_test