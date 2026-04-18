`timescale 1ps / 1ps
`default_nettype none

module dsp_fir (
    input  wire [7:0] data_in,    
    output wire [7:0] data_out,
    output wire       clk_adc,
    output wire       clk_dac,
    input  wire       mode,       
    input  wire       clk,      
    input  wire       rst_n     
);
    reg [2:0] phase;

    localparam M0 = 3'd0;
    localparam M1 = 3'd1;
    localparam M2 = 3'd2;
    localparam M3 = 3'd3;
    localparam M4 = 3'd4;
    localparam M5 = 3'd5;
    localparam M6 = 3'd6;
    localparam M7 = 3'd7;

    assign clk_adc = (phase == M1 || phase == M2 || phase == M3 || phase == M4) ? 1'b1 : 1'b0;
    assign clk_dac = ~clk_adc;

    reg signed [7:0]  fir_coeff [0:7];
    reg signed [7:0]  data_pipe [0:7];
    reg signed [7:0] mux_d, mux_c;
    reg signed [18:0] acc; 
    reg [7:0] result_reg; 
    
    integer i;
    wire signed [7:0] data_in_s = {~data_in[7], data_in[6:0]};
    
    // Combinational logics
    always @(*) begin
        case (phase)
            M0: begin 
                mux_d = data_pipe[0]; mux_c = fir_coeff[0]; 
            end
            M1: begin 
                mux_d = data_pipe[1]; mux_c = fir_coeff[1]; 
            end
            M2: begin
                mux_d = data_pipe[2]; mux_c = fir_coeff[2]; 
            end
            M3: begin
                mux_d = data_pipe[3]; mux_c = fir_coeff[3]; 
            end
            M4: begin
                mux_d = data_pipe[4]; mux_c = fir_coeff[4]; 
            end
            M5: begin
                mux_d = data_pipe[5]; mux_c = fir_coeff[5]; 
            end
            M6: begin
                mux_d = data_pipe[6]; mux_c = fir_coeff[6]; 
            end
            M7: begin
                mux_d = data_pipe[7]; mux_c = fir_coeff[7]; 
            end

        endcase
    end

    // Multipliers
    wire signed [15:0] p0 = mux_d * mux_c;
    // Adders
    wire signed [18:0] next_acc = acc + p0;

    // Sequential logics
    always @(posedge clk) begin
        if (!rst_n) begin
            phase <= M0;
            acc   <= 19'sd0;
            result_reg <= 8'h80; // Output is MSB flipped, this ensure the output 0
            for (i=0; i<8; i=i+1) begin
                fir_coeff[i] <= 8'sd0;
                data_pipe[i] <= 8'sd0;
            end
        end 
        else if (mode) begin
            // Coefficient loading
            fir_coeff[0] <= $signed(data_in);
            for (i=1; i<8; i=i+1) fir_coeff[i] <= fir_coeff[i-1];
            phase <= M0;
            acc   <= 19'sd0;
        end 
        else begin
            phase <= phase + 1'b1;
            
            if (phase == M0) begin
                acc[15:0] <= p0; // Store first result
                acc[18:16] <= 3'b000; // LSB set to zeros
            end
            else 
                acc <= next_acc;
            if (phase == M7) begin
                result_reg <= {~next_acc[14], next_acc[13:7]};
                data_pipe[0] <= data_in_s;
                data_pipe[1] <= data_pipe[0];
                data_pipe[2] <= data_pipe[1];
                data_pipe[3] <= data_pipe[2];
                data_pipe[4] <= data_pipe[3];
                data_pipe[5] <= data_pipe[4];
                data_pipe[6] <= data_pipe[5];
                data_pipe[7] <= data_pipe[6];

            end
        end
    end

    assign data_out = result_reg;

endmodule