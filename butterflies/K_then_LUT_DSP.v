`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 03:20:56 PM
// Design Name: 
// Module Name: K-DSP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Area: 6 LUT per 3 bit multiplermm 4 3bit multipliers + 18 LUTs adder
// so 42 LUTs per 6 bit multiplier, 52 LUts for 7 bit multiplier
// mults total: 84+52=136
// adders total: 75=6+6+18+12+14+19 for multiplier total, 
// Kred: LUT: 12
// 10+12+12= 33 LUts
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module K_then_LUT_DSP(
    input clk,
    input [11:0] a,
    input [11:0] b,
    output [11:0] c_mod_q
    );



    
(* use_dsp = "yes" *) reg [23:0] high_reg;


always @(posedge clk) begin
    high_reg <= a*b;

end

// stage 1



wire [16:0] Kred_upper;
wire [10:0] Kred_lower;
assign Kred_upper =  high_reg[23:8] - {2'b0, high_reg[7:0], 3'b0};
assign Kred_lower = {2'b0, high_reg[7:0]} + {high_reg[7:0], 2'b0};
wire [16:0] t1;
assign t1 = Kred_upper - Kred_lower;


//wire [10:0] eleven_bit_temp_sum;
//assign eleven_bit_temp_sum = {high_reg[7:0], 2'b0} + high_reg[7:0];

//wire [11:0] twelve_bit_temp_sum = eleven_bit_temp_sum + {high_reg[7:0], 3'b0};

//wire [16:0] t1 = high_reg[23:8] - twelve_bit_temp_sum;


wire [16:0] LUT_input;
assign LUT_input = t1;

// stage 2 with LUT solving the problem of t1 potentially being negative
function [63:0] LUT_lower_bits;
 input [3:0] LUT_lower;
 integer k;
 integer k_signed;
 integer full_output_low;
 begin
    for (k=0; k<64; k=k+1) begin
        k_signed = 3329+k[4:0] - 32*k[5];
        full_output_low = 3329 - ((k_signed << 11) % 3329);
        LUT_lower_bits[k] = full_output_low[LUT_lower];
    end
 end
endfunction






wire [11:0] LUT_out_low;

generate
    genvar k;
   // LUT6: 6-input Look-Up Table with general output
   //       Virtex-7
   // Xilinx HDL Language Template, version 2020.2
    for (k=0; k<12; k=k+1) begin: LUTS_new
     LUT6 #(
     .INIT(LUT_lower_bits(k))  // Specify LUT Contents
      ) LUT6_inst_low (
             .O(LUT_out_low[k]),   // LUT general output
         .I0(LUT_input[11]), // LUT input
         .I1(LUT_input[12]), // LUT input
         .I2(LUT_input[13]), // LUT input
         .I3(LUT_input[14]), // LUT input
         .I4(LUT_input[15]), // LUT input
         .I5(LUT_input[16])  // LUT input
      );
    end
endgenerate


wire [12:0] difference;
assign difference = LUT_input[10:0] - LUT_out_low;// the lower 11 bits don't care whether they're positive or negative, they are the same.


wire [13:0] subtracted_2;


conditional_add inst1(clk, difference, c_mod_q);



endmodule
