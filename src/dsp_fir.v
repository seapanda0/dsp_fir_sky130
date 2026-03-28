module dsp_fir(
    input  wire [7:0] data_in,    // Dedicated inputs
    output wire [7:0] data_out,   // Dedicated outputs
    input  wire       mode,       // 0: filter run mode, 1: coefficient load mode
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // localparam R = 4'd0;  // Reset state
    // localparam C0 = 4'd1; // First coeffcient
    // localparam C1 = 4'd2; //
    // localparam C2 = 4'd3; //
    // localparam C3 = 4'd4;
    // localparam C4 = 4'd5;
    // localparam C5 = 4'd6;
    // localparam C6 = 4'd7;
    // localparam C7 = 4'd8;
    // localparam M = 4'd7;  // First math stage

    // FSM Disabled

    // reg [3:0] state, next_state;

    // // FSM Switching
    // always @(*) begin
    //     if (!rst_n) begin
    //         next_state <= R;
    //     end
    //     else begin
    //         case (state)
    //             R : next_state <= C0; 
    //             C0 : next_state <= C1;
    //             C1 : next_state <= C2;
    //             C2 : next_state <= C3;
    //             C3 : next_state <= C4;
    //             C4 : next_state <= C5;
    //             C5 : next_state <= C6;
    //             C6 : next_state <= C7;
    //             C7 : next_state <= M;
    //             default: next_state <= R; 
    //         endcase 
    //     end
    // end

    // always @(posedge clk) begin
    //     if(!rst_n) begin
    //         state <= R;
    //     end
    //     else begin
    //         state <= next_state;
    //     end
    // end

    // Register for 8 x 8 bit filter coefficients 
    reg signed [7:0] fir_coeff [0:7];

    // Load the coefficients when mode = 1
    integer  i;
    always @(posedge clk) begin
        if (!rst_n) begin
            for(i=0; i<8; i=i+1) begin
                fir_coeff[i] <= 8'b0;
            end
        end
        else if (mode) begin
            fir_coeff[0] <= data_in;
            fir_coeff[1] <= fir_coeff[0];
            fir_coeff[2] <= fir_coeff[1];
            fir_coeff[3] <= fir_coeff[2];
            fir_coeff[4] <= fir_coeff[3];
            fir_coeff[5] <= fir_coeff[4];
            fir_coeff[6] <= fir_coeff[5];
            fir_coeff[7] <= fir_coeff[6];
        end
    end

    // Prevent registers from be optimized out
    assign data_out = fir_coeff[data_in[2:0]];

endmodule
